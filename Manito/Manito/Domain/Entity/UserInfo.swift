//
//  UserInfo.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation

///
/// 유저 정보에 대한 Entity
///
struct UserInfo {
    /// 유저 고유 id 값
    let id: String
    /// 유저 닉네임
    let nickname: String
}

extension UserInfo: Hashable {
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
