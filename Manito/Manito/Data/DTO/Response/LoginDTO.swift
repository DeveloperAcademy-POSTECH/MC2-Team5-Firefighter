//
//  LoginDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct LoginDTO: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let nickname: String?
    let isNewMember: Bool?
    let userSettingDone: Bool?
}
