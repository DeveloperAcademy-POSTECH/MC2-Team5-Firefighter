//
//  DetailWaitUseCase.swift
//  Manito
//
//  Created by Mingwan Choi on 10/9/23.
//

import Combine
import Foundation

protocol DetailWaitUseCase {
    var roomInformation: RoomInfo { get set }
    
    func fetchRoomInformaion(roomId: String) async throws -> RoomInfoDTO
    func patchStartManitto(roomId: String) async throws -> UserInfoDTO
    func deleteRoom(roomId: String) async throws -> Int
    func deleteLeaveRoom(roomId: String) async throws -> Int
}

final class DetailWaitUseCaseImpl: DetailWaitUseCase {
    
    // MARK: - property
    
    @Published var roomInformation: RoomInfo = RoomInfo.emptyRoom
    
    private let repository: DetailRoomRepository
    
    // MARK: - init
    
    init(repository: DetailRoomRepository) {
        self.repository = repository
    }
    
    // MARK: - func
    
    func fetchRoomInformaion(roomId: String) async throws -> RoomInfoDTO {
        do {
            let roomInformation = try await self.repository.fetchRoomInfo(roomId: roomId)
            self.roomInformation = roomInformation.toRoomInfo()
            return roomInformation
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    func patchStartManitto(roomId: String) async throws -> UserInfoDTO {
        do {
            let userInformation = try await self.repository.patchStartManitto(roomId: roomId)
            return userInformation
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    func deleteRoom(roomId: String) async throws -> Int {
        do {
            let statusCode = try await self.repository.deleteRoom(roomId: roomId)
            return statusCode
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> Int {
        do {
            let statusCode = try await self.repository.deleteLeaveRoom(roomId: roomId)
            return statusCode
        } catch {
            throw NetworkError.unknownError
        }
    }
}
