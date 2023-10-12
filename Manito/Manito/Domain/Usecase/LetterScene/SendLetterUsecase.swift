//
//  SendLetterUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/24.
//

import Combine
import Foundation

protocol SendLetterUsecase {
    func dispatchLetter(roomId: String, image: Data?, letter: LetterRequestDTO, missionId: String) async throws -> Int
}

final class SendLetterUsecaseImpl: SendLetterUsecase {

    // MARK: - property

    private let repository: LetterRepository

    // MARK: - init

    init(repository: LetterRepository) {
        self.repository = repository
    }

    // MARK: - Public - func

    func dispatchLetter(roomId: String, image: Data?, letter: LetterRequestDTO, missionId: String) async throws -> Int {
        do {
            let statusCode = try await self.repository.dispatchLetter(roomId: roomId,
                                                                      image: image,
                                                                      letter: letter,
                                                                      missionId: missionId)
            switch statusCode {
            case 200..<300: return statusCode
            default: throw LetterUsecaseError.failedToSendLetter
            }
        } catch {
            throw LetterUsecaseError.failedToSendLetter
        }
    }
}
