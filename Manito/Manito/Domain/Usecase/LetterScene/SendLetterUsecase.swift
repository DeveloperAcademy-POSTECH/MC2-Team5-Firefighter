//
//  SendLetterUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/24.
//

import Combine
import Foundation

protocol SendLetterUsecase {
    func dispatchLetter(roomId: String, image: Data?, letter: LetterRequestDTO, missionId: String) async throws -> Result<Void, Error>
}

final class SendLetterUsecaseImpl: SendLetterUsecase {

    // MARK: - property

    private let repository: LetterRepository

    // MARK: - init

    init(repository: LetterRepository) {
        self.repository = repository
    }

    // MARK: - Public - func

    func dispatchLetter(roomId: String, image: Data?, letter: LetterRequestDTO, missionId: String) async throws -> Result<Void, Error> {
//        do {
//            let statusCode = try await self.letterRepository.dispatchLetter(roomId: self.roomId,
//                                                                            image: jpegData,
//                                                                            letter: letterDTO,
//                                                                            missionId: self.missionId)
//            switch statusCode {
//            case 200..<300: completionHandler(.success(()))
//            default: completionHandler(.failure(.unknownError))
//            }
//        } catch NetworkError.serverError {
//            completionHandler(.failure(.serverError))
//        } catch NetworkError.clientError(let message) {
//            completionHandler(.failure(.clientError(message: message)))
//        }
        return .success(())
    }
}
