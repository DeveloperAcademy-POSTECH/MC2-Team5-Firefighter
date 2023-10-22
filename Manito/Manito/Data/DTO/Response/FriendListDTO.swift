//
//  FriendListDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 방에 참여한 멤버들의 정보를 반환하는 데이터 모델 DTO입니다.
///

struct FriendListDTO: Decodable {
    /// 멤버 수
    let count: Int?
    /// 멤버들 정보
    let members: [MemberInfoDTO]?
}

extension FriendListDTO {
    func toFriendList() -> FriendList {
        return FriendList(count: self.count ?? 0,
                          members: self.members?.compactMap { $0.toMemberInfo() } ?? [])
    }
}

struct MemberInfoDTO: Decodable {
    /// 닉네임
    let nickname: String?
    /// 선택한 컬러 인덱스
    let colorIndex: Int?

    enum CodingKeys: String, CodingKey {
        case nickname
        case colorIndex = "colorIdx"
    }
}

extension MemberInfoDTO {
    func toMemberInfo() -> MemberInfo {
        return MemberInfo(nickname: self.nickname ?? "",
                          colorIndex: self.colorIndex ?? 0)
    }
}
