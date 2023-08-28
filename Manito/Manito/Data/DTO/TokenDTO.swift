//
//  TokenDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct TokenDTO: Codable {
    let accessToken: String?
    let refreshToken: String?
}
