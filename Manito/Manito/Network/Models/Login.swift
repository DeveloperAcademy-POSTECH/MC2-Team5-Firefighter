//
//  Login.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

struct Login: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let nickname: String?
    let isNewMember: Bool?
    let userSettingDone: Bool?
}
