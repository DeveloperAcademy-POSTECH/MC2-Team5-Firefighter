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
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
}