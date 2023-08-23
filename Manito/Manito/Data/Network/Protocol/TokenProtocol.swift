//
//  TokenProtocol.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/14.
//

import Foundation

protocol TokenProtocol {
    func patchRefreshToken(dto: Token) async throws -> Token?
}
