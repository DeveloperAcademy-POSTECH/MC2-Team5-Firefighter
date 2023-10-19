//
//  ParticipateRoomService.swift
//  Manito
//
//  Created by 이성호 on 2023/09/04.
//

import Foundation

protocol ParticipateRoomServicable {
    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO
    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int
}

final class ParticipateRoomService: ParticipateRoomServicable {
    
    private let repository: RoomParticipationRepository
    
    init(repository: RoomParticipationRepository) {
        self.repository = repository
    }
    
    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO {
        do {
            let roomInfo = try await self.repository.dispatchVerifyCode(code: code)
            return roomInfo
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
    
    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int {
        do {
            let statusCode = try await self.repository.dispatchJoinRoom(roomId: roomId, member: member)
            return statusCode
        }
    }
}
