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
    
    let roomId: String
    private var cancellable = Set<AnyCancellable>()
    private let usecase: DetailWaitUseCase
    private let changeButtonSubject = PassthroughSubject<Void, NetworkError>()
    private let roomInfoTestSubject = PassthroughSubject<RoomInfo, NetworkError>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let codeCopyButtonDidTap: AnyPublisher<Void, Never>
        let startButtonDidTap: AnyPublisher<Void, Never>
        let editMenuButtonDidTap: AnyPublisher<Void, Never>
        let deleteMenuButtonDidTap: AnyPublisher<Void, Never>
        let leaveMenuButtonDidTap: AnyPublisher<Void, Never>
        let changeButtonDidTap: AnyPublisher<Void, Never>
        let roomDidCreate: AnyPublisher<Void, Never>
        
        init(viewDidLoad: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             codeCopyButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             startButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             editMenuButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             deleteMenuButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             leaveMenuButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             changeButtonDidTap: AnyPublisher<Void, Never> = Empty<Void,Never>().eraseToAnyPublisher(),
             roomDidCreate: AnyPublisher<Void, Never> = Empty<Void, Never>().eraseToAnyPublisher()) {
            self.viewDidLoad = viewDidLoad
            self.codeCopyButtonDidTap = codeCopyButtonDidTap
            self.startButtonDidTap = startButtonDidTap
            self.editMenuButtonDidTap = editMenuButtonDidTap
            self.deleteMenuButtonDidTap = deleteMenuButtonDidTap
            self.leaveMenuButtonDidTap = leaveMenuButtonDidTap
            self.changeButtonDidTap = changeButtonDidTap
            self.roomDidCreate = roomDidCreate
        }
    }
    
    struct Output {
        let roomInformation: AnyPublisher<RoomInfo, Error>
        let code: AnyPublisher<String, Never>
        let manitteeNickname: AnyPublisher<UserInfo, Error>
        let editRoomInformation: AnyPublisher<EditRoomInformation, Never>
        let deleteRoom: AnyPublisher<Int, Error>
        let leaveRoom: AnyPublisher<Int, Error>
        let passedStartDate: AnyPublisher<PassedStartDateAndIsOwner, Never>
        let invitedCodeView: PassthroughSubject<RoomInfo, NetworkError>
    }
    
    func transform(_ input: Input) -> Output {
        let viewDidLoad = input.viewDidLoad
            .asyncMap { [weak self] _ in
                return try await self?.fetchRoomInformation(roomId: self?.roomId ?? "")
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let codeOutput = input.codeCopyButtonDidTap
            .map { [weak self] _ -> String in
                guard let self else { return "" }
                return self.makeCode(roomInformation: self.usecase.roomInformation)
            }
            .eraseToAnyPublisher()
        
        let manitteeOutput = input.startButtonDidTap
            .asyncMap { [weak self] _ in
                return try await self?.patchStartManitto(roomId: self?.roomId ?? "")
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let editRoomInformationOutput = input.editMenuButtonDidTap
            .map { [weak self] _ -> EditRoomInformation in
                guard let self else { return (RoomInfo.emptyRoom, .information) }
                return self.makeEditRoomInformation(roomInformation: self.usecase.roomInformation)
            }
            .eraseToAnyPublisher()
        
        let deleteOutput = input.deleteMenuButtonDidTap
            .asyncMap { [weak self] _ in
                return try await self?.deleteRoom(roomId: self?.roomId ?? "")
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let leaveRoomOutput = input.leaveMenuButtonDidTap
            .asyncMap { [weak self] _ in
                return try await self?.deleteLeaveRoom(roomId: self?.roomId ?? "")
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        let passedStartDateOutput = input.viewDidLoad
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .map { [weak self] _ -> PassedStartDateAndIsOwner in
                guard let self else { return (false, false) }
                return self.makeIsAdmin(roomInformation: self.usecase.roomInformation)
            }
            .eraseToAnyPublisher()
        
        input.changeButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                guard let roomId = self?.roomId else { return }
                //                self?.requestWaitRoomInfo(roomId: roomId)
            })
            .store(in: &self.cancellable)
        
        input.roomDidCreate
            .sink(receiveValue: { [weak self] _ in
                guard let roomId = self?.roomId else { return }
                //                self?.requestWaitRoomInfoTest(roomId: roomId)
            })
            .store(in: &self.cancellable)
        
        return Output(
            roomInformation: viewDidLoad,
            code: codeOutput,
            manitteeNickname: manitteeOutput,
            editRoomInformation: editRoomInformationOutput,
            deleteRoom: deleteOutput,
            leaveRoom: leaveRoomOutput,
            passedStartDate: passedStartDateOutput,
            invitedCodeView: self.roomInfoTestSubject
        )
    }
    
    // MARK: - init
    
    init(roomId: String, usecase: DetailWaitUseCase) {
        self.roomId = roomId
        self.usecase = usecase
    }
    
    // MARK: - func
    
    func makeRoomInformation() -> RoomInfo {
        return self.usecase.roomInformation
    }
    
    private func makeCode(roomInformation: RoomInfo) -> String {
        return roomInformation.invitation.code
    }
    
    private func manitteNickname() -> String {
        return self.usecase.roomInformation.manittee.nickname
    }
    
    func makeEditRoomInformation(roomInformation: RoomInfo) -> EditRoomInformation {
        let editMode: DetailEditView.EditMode = .information
        return (roomInformation, editMode)
    }
    
    func makeIsAdmin(roomInformation: RoomInfo) -> PassedStartDateAndIsOwner {
        
        return (roomInformation.roomInformation.isStartDatePast, roomInformation.admin)
    }
    
    private func fetchRoomInformation(roomId: String) async throws -> RoomInfo {
        let roomInformation = try await self.usecase.fetchRoomInformaion(roomId: roomId)
        return roomInformation.toRoomInfo()
    }
    
    private func patchStartManitto(roomId: String) async throws -> UserInfo {
        let userInfo = try await self.usecase.patchStartManitto(roomId: roomId)
        return userInfo.toUserInfo()
    }
    
    private func deleteRoom(roomId: String) async throws -> Int {
        let statusCode = try await self.usecase.deleteRoom(roomId: roomId)
        return statusCode
    }
    
    private func deleteLeaveRoom(roomId: String) async throws -> Int {
        let statusCode = try await self.usecase.deleteLeaveRoom(roomId: roomId)
        return statusCode
    }
}
