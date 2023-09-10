//
//  LetterUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

import MTNetwork

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
        } catch {
            throw LetterUsecaseError.failedToFetchLetter
        }
    }

    func fetchReceiveLetter(roomId: String) async throws -> [MessageListItemDTO] {
        do {
            let letterData = try await self.repository.fetchReceiveLetter(roomId: roomId)
            self.setManitteeId(letterData.manittee?.id)
            return letterData.messages
        } catch {
            throw LetterUsecaseError.failedToFetchLetter
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
