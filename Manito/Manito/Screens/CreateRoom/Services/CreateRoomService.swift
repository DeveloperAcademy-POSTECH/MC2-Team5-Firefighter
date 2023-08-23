//
//  CreateRoomService.swift
//  Manito
//
//  Created by 이성호 on 2023/08/23.
//

import Foundation

protocol CreateRoomSeviceable {
    func postCreateRoom(body: CreateRoomDTO) async throws -> Int
}

final class CreateRoomService: CreateRoomSeviceable {
    
    private let api: RoomProtocol
    
    init(api: RoomProtocol) {
        self.api = api
    }
    
    func postCreateRoom(body: CreateRoomDTO) async throws -> Int {
        do {
            let roomId = try await self.api.postCreateRoom(body: body)
            if let roomId {
                return roomId
            }
            else {
                throw NetworkError.serverError
            }
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
}
