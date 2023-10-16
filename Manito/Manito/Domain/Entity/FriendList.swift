//
//  FriendList.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Foundation

///
/// 방에 참여하는 멤버 정보를 반환하는
/// 데이터 모델 Entity입니다.
///

struct FriendList {
    let count: Int
    let members: [MemberInfo]
}

struct MemberInfo {
    let nickname: String
    let colorIndex: Int
}
