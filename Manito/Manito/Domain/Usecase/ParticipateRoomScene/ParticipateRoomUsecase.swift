//
//  ParticipateRoomUsecase.swift
//  Manito
//
//  Created by 이성호 on 2023/09/04.
//

import Foundation

protocol ParticipateRoomUsecase {
    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO
    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int
}

final class ParticipateRoomUsecaseImpl: ParticipateRoomUsecase {
    
    // MARK: - property
    
    private let repository: RoomParticipationRepository
    
    // MARK: - init
    
    init(repository: RoomParticipationRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO {
        do {
            let roomInfo = try await self.repository.dispatchVerifyCode(code: code)
            return roomInfo
        } catch ParticipateRoomError.invailedCode {
            throw ParticipateRoomError.invailedCode
        } catch ParticipateRoomError.clientError {
            throw ParticipateRoomError.clientError
        }
    }
    
    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int {
        do {
            let statusCode = try await self.repository.dispatchJoinRoom(roomId: roomId, member: member)
            return statusCode
        }
    }
}
