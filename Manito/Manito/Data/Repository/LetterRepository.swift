//
//  LetterRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol LetterRepository {
    func dispatchLetter(roomId: String, image: Data?, letter: LetterRequestDTO, missionId: String) async throws -> Int
    func fetchSendLetter(roomId: String) async throws -> LetterDTO
    func fetchReceiveLetter(roomId: String) async throws -> LetterDTO
}

final class LetterRepositoryImpl: LetterRepository {

    private var provider = Provider<LetterEndPoint>()

    func dispatchLetter(roomId: String, image: Data?, letter: LetterRequestDTO, missionId: String) async throws -> Int {
        let response = try await self.provider
            .request(.dispatchLetter(roomId: roomId,
                                     image: image,
                                     letter: letter,
                                     missionId: missionId))
        return response.statusCode
    }

    func fetchSendLetter(roomId: String) async throws -> LetterDTO {
        let response = try await self.provider
            .request(.fetchSendLetter(roomId: roomId))
        return try response.decode()
    }

    func fetchReceiveLetter(roomId: String) async throws -> LetterDTO {
        let response = try await self.provider
            .request(.fetchReceiveLetter(roomId: roomId))
        return try response.decode()
    }
}
