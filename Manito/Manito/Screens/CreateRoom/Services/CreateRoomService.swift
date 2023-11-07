//
//  CreateRoomService.swift
//  Manito
//
//  Created by 이성호 on 2023/08/23.
//

import Foundation

protocol CreateRoomSevicable {
    func dispatchCreateRoom(room: CreatedRoomRequestDTO) async throws -> Int
}

final class CreateRoomService: CreateRoomSevicable {
    
    private let repository: RoomParticipationRepository
    
    init(repository: RoomParticipationRepository) {
        self.repository = repository
    }
    
    func dispatchCreateRoom(room: CreatedRoomRequestDTO) async throws -> Int {
        do {
            let roomId = try await self.repository.dispatchCreateRoom(room: room)
            return roomId
        } catch {
            throw CreateRoomError.failedToCreateRoom
        }
    }
}
