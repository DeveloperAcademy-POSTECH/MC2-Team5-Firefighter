//
//  RefreshToken.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

struct RefreshToken: Codable {
    let accessToken: String?
    let refreshToken: String?
}
