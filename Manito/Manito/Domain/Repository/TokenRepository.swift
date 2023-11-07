//
//  TokenRepository.swift
//  Manito
//
//  Created by 이성호 on 10/31/23.
//

import Foundation

protocol TokenRepository {
    func patchRefreshToken(token: TokenDTO) async throws -> TokenDTO
}
