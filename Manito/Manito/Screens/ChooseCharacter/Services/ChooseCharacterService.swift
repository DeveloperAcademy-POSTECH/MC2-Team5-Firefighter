//
//  ChooseCharacterService.swift
//  Manito
//
//  Created by 이성호 on 2023/09/23.
//

import Foundation

final class ChooseCharacterService {
    
    private let repository: RoomParticipationRepository
    
    init(repository: RoomParticipationRepository) {
        self.repository = repository
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
