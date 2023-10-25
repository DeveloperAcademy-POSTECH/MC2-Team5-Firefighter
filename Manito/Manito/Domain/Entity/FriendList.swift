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
    /// 방 참여 멤버 수
    let count: Int
    /// 방 참여 멤버 정보
    let members: [MemberInfo]
}

struct MemberInfo: Hashable {
    /// 닉네임
    let nickname: String
    /// 멤버 색깔 인덱스
    let colorIndex: Int
}
