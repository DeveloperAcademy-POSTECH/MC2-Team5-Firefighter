//
//  ParticipantList.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 마니또 참여 인원에 대한 Entity
///
struct ParticipantList {
    /// 현재 참여한 총 인원 수
    let count: Int
    /// 참여한 유저들 리스트
    let members: [UserInfo]
}

extension ParticipantList {
    var membersNickname: [String] {
        return members.map { $0.nickname }
    }
}

extension ParticipantList: Hashable {
    static let testParticipantList = ParticipantList(
        count: 5,
        members: UserInfo.testUserList
    )
}
