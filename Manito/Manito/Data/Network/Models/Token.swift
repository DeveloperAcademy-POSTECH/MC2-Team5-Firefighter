//
//  Token.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

struct Token: Codable {
    let accessToken: String?
    let refreshToken: String?
}
