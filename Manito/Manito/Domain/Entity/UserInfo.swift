//
//  UserInfo.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation

struct UserInfo {
    let id: String
    let nickname: String
}

extension UserInfo: Equatable {
    static let testUserManittee = UserInfo(id: "1", nickname: "테스트마니띠")
    static let testUserManitto = UserInfo(id: "2", nickname: "테스트마니또")
    
    static let testUserList = [
        UserInfo(id: "100", nickname: "유저1"),
        UserInfo(id: "200", nickname: "유저2"),
        UserInfo(id: "300", nickname: "유저3"),
        UserInfo(id: "400", nickname: "유저4"),
        UserInfo(id: "500", nickname: "유저5")
    ]
}
