//
//  TokenAPI.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/14.
//

import Foundation

struct TokenAPI: TokenProtocol {
    private let apiService: Requestable

    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func patchRefreshToken(token: Token) async throws -> Token? {
        let request = TokenEndPoint
            .patchRefreshToken(token: token)
            .createRequest()
        return try await apiService.request(request)
    }
}
