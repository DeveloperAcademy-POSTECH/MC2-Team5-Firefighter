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

extension UserInfoDTO: Equatable {
    static let testUserManittee = UserInfoDTO(id: "1", nickname: "테스트마니띠")
    static let testUserManitto = UserInfoDTO(id: "2", nickname: "테스트마니또")
    
    static let testUserList = [
        UserInfoDTO(id: "100", nickname: "유저1"),
        UserInfoDTO(id: "200", nickname: "유저2"),
        UserInfoDTO(id: "300", nickname: "유저3"),
        UserInfoDTO(id: "400", nickname: "유저4"),
        UserInfoDTO(id: "500", nickname: "유저5")
    ]
}
