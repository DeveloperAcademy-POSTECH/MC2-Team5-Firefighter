//
//  DetailWaitViewModel.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/05/30.
//

import Combine
import Foundation

final class DetailWaitViewModel {
    
    typealias EditRoomInformation = (roomInformation: RoomInfo, mode: DetailEditView.EditMode)
    typealias PassedStartDateAndIsOwner = (passStartDate: Bool, isOwner: Bool)
    
    // MARK: - property
    
    let roomIndex: Int
    private let detailWaitService: DetailWaitServicable
    private var cancellable = Set<AnyCancellable>()
    
    private let roomInformationSubject = CurrentValueSubject<RoomInfo, NetworkError>(RoomInfo.emptyRoom)
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
        
        init(viewDidLoad: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             codeCopyButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             startButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             editMenuButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             deleteMenuButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             leaveMenuButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             changeButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher()) {
            self.viewDidLoad = viewDidLoad
            self.codeCopyButtonDidTap = codeCopyButtonDidTap
            self.startButtonDidTap = startButtonDidTap
            self.editMenuButtonDidTap = editMenuButtonDidTap
            self.deleteMenuButtonDidTap = deleteMenuButtonDidTap
            self.leaveMenuButtonDidTap = leaveMenuButtonDidTap
            self.changeButtonDidTap = changeButtonDidTap
        }
    }
    
    struct Output {
        let roomInformation: CurrentValueSubject<RoomInfo, NetworkError>
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
                guard let roomId = self?.roomIndex.description else { return }
                self?.requestWaitRoomInfo(roomId: roomId)
            })
            .store(in: &self.cancellable)
        
        let codeOutput = input.codeCopyButtonDidTap
            .map { [weak self] _ -> String in
                guard let self else { return "" }
                return self.makeCode(roomInformation: self.roomInformationSubject.value)
            }
            .eraseToAnyPublisher()
        
        input.startButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                guard let roomId = self?.roomIndex.description else { return }
                self?.requestStartManitto(roomId: roomId)
            })
            .store(in: &self.cancellable)
        
        let editRoomInformationOutput = input.editMenuButtonDidTap
            .map { [weak self] _ -> EditRoomInformation in
                guard let self else { return (RoomInfo.emptyRoom, .information) }
                return self.makeEditRoomInformation(roomInformation: self.roomInformationSubject.value)
            }
            .eraseToAnyPublisher()
        
        input.deleteMenuButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                guard let roomId = self?.roomIndex.description else { return }
                self?.requestDeleteRoom(roomId: roomId)
            })
            .store(in: &self.cancellable)
        
        input.leaveMenuButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                guard let roomId = self?.roomIndex.description else { return }
                self?.requestDeleteLeaveRoom(roomId: roomId)
            })
            .store(in: &self.cancellable)
        
        let passedStartDateOutput = input.viewDidLoad
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .map { [weak self] _ -> PassedStartDateAndIsOwner in
                guard let self else { return (false, false) }
                return self.makeIsAdmin(roomInformation: self.roomInformationSubject.value)
            }
            .eraseToAnyPublisher()
        
        input.changeButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                guard let roomId = self?.roomIndex.description else { return }
                self?.requestWaitRoomInfo(roomId: roomId)
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
    
    init(roomIndex: Int, detailWaitService: DetailWaitServicable) {
        self.roomIndex = roomIndex
        self.detailWaitService = detailWaitService
    }
    
    // MARK: - func
    
    func makeRoomInformation() -> RoomInfo {
        return self.roomInformationSubject.value
    }
    
    func makeCode(roomInformation: RoomInfo) -> String {
        return roomInformation.invitation.code
    }
    
    func makeEditRoomInformation(roomInformation: RoomInfo) -> EditRoomInformation {
        let editMode: DetailEditView.EditMode = .information
        return (roomInformation, editMode)
    }
    
    func makeIsAdmin(roomInformation: RoomInfo) -> PassedStartDateAndIsOwner {
        
        return (roomInformation.roomInformation.isStartDatePast, roomInformation.admin)
    }
    
    func setRoomInformation(room: RoomInfo) {
        self.roomInformationSubject.send(room)
    }
    
    // MARK: - network
    
    private func requestWaitRoomInfo(roomId: String) {
        Task {
            do {
                let room = try await self.detailWaitService.fetchWaitingRoomInfo(roomId: roomId)
                self.roomInformationSubject.send(room.toRoomInfo())
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.roomInformationSubject.send(completion: .failure(error))
            }
        }
    }
    
    private func requestStartManitto(roomId: String) {
        Task {
            do {
                let manittee = try await self.detailWaitService.patchStartManitto(roomId: roomId)
                guard let nickname = manittee.nickname else { return }
                self.manitteeNicknameSubject.send(nickname)
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.manitteeNicknameSubject.send(completion: .failure(error))
            }
        }
    }
    
    private func requestDeleteRoom(roomId: String) {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteRoom(roomId: roomId)
                switch statusCode {
                case 200..<300:
                    self.deleteRoomSubject.send(())
                default :
                    self.deleteRoomSubject.send(completion: .failure(.unknownError))
                }
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.deleteRoomSubject.send(completion: .failure(error))
            }
        }
    }
    
    private func requestDeleteLeaveRoom(roomId: String) {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteLeaveRoom(roomId: roomId)
                switch statusCode {
                case 200..<300:
                    self.leaveRoomSubject.send(())
                default:
                    self.leaveRoomSubject.send(completion: .failure(.unknownError))
                }
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.leaveRoomSubject.send(completion: .failure(error))
            }
        }
    }
}
