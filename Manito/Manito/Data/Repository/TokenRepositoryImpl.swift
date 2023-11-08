//
//  TokenRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

final class TokenRepositoryImpl: TokenRepository {

    private var provider = Provider<TokenEndPoint>()

    func patchRefreshToken(token: TokenDTO) async throws -> TokenDTO {
        let response = try await self.provider
            .request(.patchRefreshToken(token: token))
        return try response.decode()
    }
}
