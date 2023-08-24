//
//  TokenRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol TokenRepository {
    func patchRefreshToken(token: Token) async throws -> Token?
}

final class TokenRepositoryImpl: TokenRepository {

    private var provider = Provider<TokenEndPoint>()

    func patchRefreshToken(token: Token) async throws -> Token? {
        let response = try await self.provider.request(.patchRefreshToken(token: token))
        return try response.decode()
    }
}
