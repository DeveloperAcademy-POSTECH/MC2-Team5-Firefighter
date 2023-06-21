//
//  LetterService.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

protocol LetterServicable: Servicable {
    var manitteeId: String? { get set }
    var nickname: String { get set }

    func fetchSendLetter(roomId: String) async throws -> [Message]
    func fetchReceiveLetter(roomId: String) async throws -> [Message]
    func loadNickname()
}

final class LetterService: LetterServicable {

    // MARK: - property

    @Published var manitteeId: String?
    @Published var nickname: String = ""

    private let api: LetterProtocol

    // MARK: - init

    init(api: LetterProtocol) {
        self.api = api
    }

    // MARK: - Public - func

    func fetchSendLetter(roomId: String) async throws -> [Message] {
        do {
            let letterData = try await self.api.fetchSendLetter(roomId: roomId)
            if let letterData {
                self.setManitteeId(letterData.manittee?.id)

                return letterData.messages
            } else {
                throw NetworkError.serverError
            }
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }

    func fetchReceiveLetter(roomId: String) async throws -> [Message] {
        do {
            let letterData = try await self.api.fetchReceiveLetter(roomId: roomId)
            if let letterData {
                self.setManitteeId(letterData.manittee?.id)

                return letterData.messages
            } else {
                throw NetworkError.serverError
            }
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
