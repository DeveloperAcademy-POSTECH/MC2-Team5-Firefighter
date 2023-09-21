//
//  ParticipantList.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct ParticipantList {
    let count: Int
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
