//
//  DetailWaitViewModel.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/05/30.
//

import Combine
import Foundation

final class DetailWaitViewModel {
    
    typealias EditRoomInformation = (roomInformation: Room, mode: DetailEditView.EditMode)
    typealias PassedStartDateAndIsOwner = (passStartDate: Bool, isOwner: Bool)
    
    // MARK: - property
    
    let roomIndex: Int
    private let detailWaitService: DetailWaitAPI
    private var cancellable = Set<AnyCancellable>()
    
    private let roomInformationSubject = CurrentValueSubject<Room, NetworkError>(Room.emptyRoom)
    private let manitteeNicknameSubject = PassthroughSubject<String, NetworkError>()
    private let deleteRoomSubject = PassthroughSubject<Void, NetworkError>()
    private let leaveRoomSubject = PassthroughSubject<Void, NetworkError>()
    private let changeButtonSubject = PassthroughSubject<Void, NetworkError>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let codeCopyButtonDidTap: AnyPublisher<Void, Never>
        let startButtonDidTap: AnyPublisher<Void, Never>
        let editMenuButtonDidTap: AnyPublisher<Void, Never>
        let deleteMenuButtonDidTap: AnyPublisher<Void, Never>
        let leaveMenuButtonDidTap: AnyPublisher<Void, Never>
        let changeButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let roomInformation: CurrentValueSubject<Room, NetworkError>
        let code: AnyPublisher<String, Never>
        let manitteeNickname: PassthroughSubject<String, NetworkError>
        let editRoomInformation: AnyPublisher<EditRoomInformation, Never>
        let deleteRoom: PassthroughSubject<Void, NetworkError>
        let leaveRoom: PassthroughSubject<Void, NetworkError>
        let passedStartDate: AnyPublisher<PassedStartDateAndIsOwner, Never>
    }
    
    func transform(_ input: Input) -> Output {
        input.viewDidLoad
            .sink(receiveValue: { [weak self] _ in
                self?.requestWaitRoomInfo()
            })
            .store(in: &self.cancellable)
        
        let codeOutput = input.codeCopyButtonDidTap
            .map { [weak self] _ -> String in
                guard let self else { return "" }
                return self.makeCode()
            }
            .eraseToAnyPublisher()
        
        input.startButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.requestStartManitto()
            })
            .store(in: &self.cancellable)
        
        let editRoomInformationOutput = input.editMenuButtonDidTap
            .map { [weak self] _ -> EditRoomInformation in
                guard let self else { return (Room.emptyRoom, .information) }
                return self.makeEditRoomInformation()
            }
            .eraseToAnyPublisher()
        
        input.deleteMenuButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.requestDeleteRoom()
            })
            .store(in: &self.cancellable)
        
        input.leaveMenuButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.requestDeleteLeaveRoom()
            })
            .store(in: &self.cancellable)
        
        let passedStartDateOutput = input.viewDidLoad
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .map { [weak self] _ -> PassedStartDateAndIsOwner in
                guard let self else { return (false, false) }
                return self.makeIsAdmin()
            }
            .eraseToAnyPublisher()
        
        input.changeButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.requestWaitRoomInfo()
            })
            .store(in: &self.cancellable)
                
        return Output(
            roomInformation: self.roomInformationSubject,
            code: codeOutput,
            manitteeNickname: self.manitteeNicknameSubject,
            editRoomInformation: editRoomInformationOutput,
            deleteRoom: self.deleteRoomSubject,
            leaveRoom: self.leaveRoomSubject,
            passedStartDate: passedStartDateOutput
        )
    }
    
    // MARK: - init
    
    init(roomIndex: Int, detailWaitService: DetailWaitAPI) {
        self.roomIndex = roomIndex
        self.detailWaitService = detailWaitService
    }
    
    // MARK: - func
    
    func makeRoomInformation() -> Room {
        return self.roomInformationSubject.value
    }
    
    private func makeCode() -> String {
        let roomInformation = self.roomInformationSubject.value
        guard let code = roomInformation.invitation?.code else { return "" }
        return code
    }
    
    private func makeEditRoomInformation() -> EditRoomInformation {
        let roomInformation = self.roomInformationSubject.value
        let editMode: DetailEditView.EditMode = .information
        return (roomInformation, editMode)
    }
    
    private func makeIsAdmin() -> PassedStartDateAndIsOwner {
        let roomInformation = self.roomInformationSubject.value
        guard let isAdmin = roomInformation.admin,
            let isPassStartDate = roomInformation.roomInformation?.isStartDatePast else { return (false, false) }
        
        return (isPassStartDate, isAdmin)
    }
    
    func setRoomInformation(room: Room) {
        self.roomInformationSubject.send(room)
    }
    
    // MARK: - network
    
    private func requestWaitRoomInfo() {
        Task {
            do {
                let data = try await self.detailWaitService.getWaitingRoomInfo(roomId: self.roomIndex.description)
                if let roomInformation = data {
                    self.roomInformationSubject.send(roomInformation)
                }
            } catch NetworkError.serverError {
                self.roomInformationSubject.send(completion: .failure(.serverError))
            } catch NetworkError.clientError(let message) {
                self.roomInformationSubject.send(completion: .failure(.clientError(message: message)))
            }
        }
    }
    
    private func requestStartManitto() {
        Task {
            do {
                let data = try await self.detailWaitService.startManitto(roomId: self.roomIndex.description)
                if let manittee = data {
                    guard let nickname = manittee.nickname else { return }
                    self.manitteeNicknameSubject.send(nickname)
                }
            } catch NetworkError.serverError {
                self.manitteeNicknameSubject.send(completion: .failure(.serverError))
            } catch NetworkError.clientError(let message) {
                self.manitteeNicknameSubject.send(completion: .failure(.clientError(message: message)))
            }
        }
    }
    
    func requestDeleteRoom() {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteRoom(roomId: self.roomIndex.description)
                switch statusCode {
                case 200..<300:
                    self.deleteRoomSubject.send(())
                default:
                    self.deleteRoomSubject.send(completion: .failure(.unknownError))
                }
            } catch NetworkError.serverError {
                self.deleteRoomSubject.send(completion: .failure(.serverError))
            } catch NetworkError.clientError(let message) {
                self.deleteRoomSubject.send(completion: .failure(.clientError(message: message)))
            }
        }
    }
    
    func requestDeleteLeaveRoom() {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteLeaveRoom(roomId: self.roomIndex.description)
                switch statusCode {
                case 200..<300:
                    self.leaveRoomSubject.send(())
                default:
                    self.leaveRoomSubject.send(completion: .failure(.unknownError))
                }
            } catch NetworkError.serverError {
                self.leaveRoomSubject.send(completion: .failure(.serverError))
            } catch NetworkError.clientError(let message) {
                self.leaveRoomSubject.send(completion: .failure(.clientError(message: message)))
            }
        }
    }
}
