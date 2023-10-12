//
//  DetailWaitUseCase.swift
//  Manito
//
//  Created by Mingwan Choi on 10/9/23.
//

import Combine
import Foundation

protocol DetailWaitUseCase {
    var roomIndex: Int { get set }
    var roomInformation: RoomInfo { get set }
    
    func fetchRoomInformaion(roomIndex: String) async throws -> RoomInfoDTO
    func patchStartManitto(roomIndex: String) async throws -> UserInfoDTO
    func deleteRoom(roomIndex: String) async throws -> Int
    func deleteLeaveRoom(roomIndex: String) async throws -> Int
}

final class DetailWaitUseCaseImpl: DetailWaitUseCase {
    
    // MARK: - property
    
    var roomIndex: Int
    @Published var roomInformation: RoomInfo = RoomInfo.emptyRoom
    
    private let repository: DetailRoomRepository
    
    init(roomIndex: Int, repository: DetailRoomRepository) {
        self.roomIndex = roomIndex
        self.repository = repository
    }
    
    // MARK: - func
    
    func fetchRoomInformaion(roomIndex: String) async throws -> RoomInfoDTO {
        do {
            let roomInformation = try await self.repository.fetchRoomInfo(roomId: roomIndex)
            return roomInformation
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    func patchStartManitto(roomIndex: String) async throws -> UserInfoDTO {
        do {
            let userInformation = try await self.repository.patchStartManitto(roomId: roomIndex)
            return userInformation
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    func deleteRoom(roomIndex: String) async throws -> Int {
        do {
            let statusCode = try await self.repository.deleteRoom(roomId: roomIndex)
            return statusCode
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    func deleteLeaveRoom(roomIndex: String) async throws -> Int {
        do {
            let statusCode = try await self.repository.deleteLeaveRoom(roomId: roomIndex)
            return statusCode
        } catch {
            throw NetworkError.unknownError
        }
        
    }
    
    func setRoomInformation(_ roomInformation: RoomInfo) {
        self.roomInformation = roomInformation
    }
}
