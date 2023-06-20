//
//  LetterService.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Foundation

protocol LetterServicable: Servicable {
    func fetchSendLetter(roomId: String) async throws -> [Message]
    func fetchReceiveLetter(roomId: String) async throws -> [Message]
}

final class LetterService: LetterServicable {

    // MARK: - property

    private let api: LetterProtocol

    // MARK: - init

    init(api: LetterProtocol) {
        self.api = api
    }

    // MARK: - func

    func fetchSendLetter(roomId: String) async throws -> [Message] {
        do {
            let letterData = try await self.api.fetchSendLetter(roomId: roomId)
            if let letterData {
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
}
