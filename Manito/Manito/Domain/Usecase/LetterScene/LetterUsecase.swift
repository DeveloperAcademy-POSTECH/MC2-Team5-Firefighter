//
//  LetterUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

protocol LetterUsecase {
    var manitteeId: String? { get set }
    var nickname: String { get set }

    func fetchSendLetter(roomId: String) async throws -> [MessageListItemDTO]
    func fetchReceiveLetter(roomId: String) async throws -> [MessageListItemDTO]
    func loadNickname()
}

final class LetterUsecaseImpl: LetterUsecase {

    // MARK: - property

    @Published var manitteeId: String?
    @Published var nickname: String = ""

    private let repository: LetterRepository

    // MARK: - init

    init(repository: LetterRepository) {
        self.repository = repository
    }

    // MARK: - Public - func

    func fetchSendLetter(roomId: String) async throws -> [MessageListItemDTO] {
        do {
            let letterData = try await self.repository.fetchSendLetter(roomId: roomId)
            self.setManitteeId(letterData.manittee?.id)
            return letterData.messages
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }

    func fetchReceiveLetter(roomId: String) async throws -> [MessageListItemDTO] {
        do {
            let letterData = try await self.repository.fetchReceiveLetter(roomId: roomId)
            self.setManitteeId(letterData.manittee?.id)
            return letterData.messages
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }

    func loadNickname() {
        self.nickname = UserDefaultStorage.nickname
    }

    // MARK: - Private - func

    private func setManitteeId(_ id: String?) {
        self.manitteeId = id
    }

}
