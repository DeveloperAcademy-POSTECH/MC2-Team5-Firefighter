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
        let roomInformation: AnyPublisher<Result<RoomInfo, Error>, Never>
        let code: AnyPublisher<String, Never>
        let selectManitteeInfo: AnyPublisher<(userInfo: UserInfo?, roomId: String?), Error>
        let editRoomInformation: AnyPublisher<EditRoomInformation, Never>
        let deleteRoom: AnyPublisher<Int, Error>
        let leaveRoom: AnyPublisher<Int, Error>
        let passedStartDate: AnyPublisher<PassedStartDateAndIsOwner, Never>
        let invitedCodeView: AnyPublisher<RoomInfo, Never>
        let changeOutput: AnyPublisher<RoomInfo, Error>
    }
    
    // MARK: - property
    
    let roomId: String
    private var cancellable = Set<AnyCancellable>()
    private let usecase: DetailWaitUseCase
    
    // MARK: - init
    
    init(roomId: String, usecase: DetailWaitUseCase) {
        self.roomId = roomId
        self.usecase = usecase
    }
    
    // MARK: - func
    
    func transform(_ input: Input) -> Output {
        let viewDidLoad = input.viewDidLoad
            .asyncMap { [weak self] _ -> Result<RoomInfo, Error> in
                do {
                    let roomInfo = try await self?.fetchRoomInformation(roomId: self?.roomId ?? "")
                    return .success(roomInfo ?? .emptyRoom)
                } catch(let error) {
                    return .failure(error)
                }
            }
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
            .compactMap { [weak self] in (userInfo: $0, roomId: self?.roomId) }
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
        
        let passedStartDateOutput = viewDidLoad
            .map { [weak self] result -> PassedStartDateAndIsOwner in
                switch result {
                case .success(let roomInfo):
                    guard let self else { return (false, false) }
                    return self.makeIsAdmin(roomInformation: roomInfo)
                case .failure:
                    return (false, false)
                }
            }
            .eraseToAnyPublisher()
        
        let zipPublisher = Publishers.Zip(viewDidLoad, input.roomDidCreate)
            .compactMap { $0.0 }
            .map { result -> RoomInfo in
                switch result {
                case .success(let roomInfo):
                    return roomInfo
                case .failure:
                    return RoomInfo.emptyRoom
                }
            }
            .eraseToAnyPublisher()
        
        let changeButtonOutput = input.changeButtonDidTap
            .asyncMap { [weak self] _ in
                return try await self?.fetchRoomInformation(roomId: self?.roomId ?? "")
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        return Output(
            roomInformation: viewDidLoad,
            code: codeOutput,
            selectManitteeInfo: manitteeOutput,
            editRoomInformation: editRoomInformationOutput,
            deleteRoom: deleteOutput,
            leaveRoom: leaveRoomOutput,
            passedStartDate: passedStartDateOutput,
            invitedCodeView: zipPublisher,
            changeOutput: changeButtonOutput
        )
    }
    
    func makeRoomInformation() -> RoomInfo {
        return self.usecase.roomInformation
    }
    
    func makeCode(roomInformation: RoomInfo) -> String {
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
