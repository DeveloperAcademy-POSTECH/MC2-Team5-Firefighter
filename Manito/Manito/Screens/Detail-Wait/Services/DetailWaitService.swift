//
//  DetailWaitService.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/07/03.
//

import Foundation

protocol DetailWaitServicable {
    func fetchWaitingRoomInfo(roomId: String) async throws -> RoomInfoDTO
    func patchStartManitto(roomId: String) async throws -> UserInfoDTO
    func deleteRoom(roomId: String) async throws -> Int
    func deleteLeaveRoom(roomId: String) async throws -> Int
}

final class DetailWaitService: DetailWaitServicable {
    
    private let repository: DetailRoomRepository
    
    init(repository: DetailRoomRepository) {
        self.repository = repository
    }
    
    func fetchWaitingRoomInfo(roomId: String) async throws -> RoomInfoDTO {
        do {
            let roomData = try await self.repository.fetchRoomInfo(roomId: roomId)
            return roomData
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
    
    func patchStartManitto(roomId: String) async throws -> UserInfoDTO {
        do {
            let manitteeData = try await self.repository.patchStartManitto(roomId: roomId)
            return manitteeData
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
    
    func deleteRoom(roomId: String) async throws -> Int {
        do {
            let statusCode = try await self.repository.deleteRoom(roomId: roomId)
            return statusCode
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> Int {
        do {
            let statusCode = try await self.repository.deleteLeaveRoom(roomId: roomId)
            return statusCode
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
}
