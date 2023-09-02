//
//  UserInfoDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct UserInfoDTO: Decodable {
    let id: String?
    let nickname: String?
}

extension UserInfoDTO {
    func toUserInfo() -> UserInfo {
        return UserInfo(id: self.id, nickname: self.nickname)
    }
}
