//
//  DetailWaitService.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/07/03.
//

import Foundation

protocol DetailWaitServicable {
    func fetchWaitingRoomInfo(roomId: String) async throws -> Room
    func patchStartManitto(roomId: String) async throws -> Manittee
    func deleteRoom(roomId: String) async throws -> Int
    func deleteLeaveRoom(roomId: String) async throws -> Int
}

final class DetailWaitService: DetailWaitServicable {
    
    private let api: DetailWaitProtocol
    
    init(api: DetailWaitProtocol) {
        self.api = api
    }
    
    func fetchWaitingRoomInfo(roomId: String) async throws -> Room {
        do {
            let roomData = try await self.api.getWaitingRoomInfo(roomId: roomId)
            if let roomData {
                return roomData
            } else {
                throw NetworkError.serverError
            }
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
    
    func patchStartManitto(roomId: String) async throws -> Manittee {
        do {
            let manitteeData = try await self.api.startManitto(roomId: roomId)
            if let manitteeData {
                return manitteeData
            } else {
                throw NetworkError.serverError
            }
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
    
    func deleteRoom(roomId: String) async throws -> Int {
        do {
            let statusCode = try await self.api.deleteRoom(roomId: roomId)
            return statusCode
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> Int {
        do {
            let statusCode = try await self.api.deleteLeaveRoom(roomId: roomId)
            return statusCode
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
}
