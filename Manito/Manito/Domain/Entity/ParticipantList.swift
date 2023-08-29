//
//  ParticipantList.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct ParticipantList: Decodable {
    let count: Int
    let members: [UserInfoDTO]
}

extension ParticipantList {
    var membersNickname: [String] {
        return members.map { $0.nickname ?? "" }
    }
}

#if DEBUG
extension ParticipantList {
    static let testParticipantList = ParticipantList(
        count: 5,
        members: UserInfoDTO.testUserList
    )
}
#endif
