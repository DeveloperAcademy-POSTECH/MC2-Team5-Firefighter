//
//  Room.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

// FIXME: 모든 변수들을 만들어 뒀다가 조회할 때 추가하는 방식인데 괜찮은지..?
struct Room: Decodable {
    let id: Int?
    let title: String?
    let state: String?
    let participatingCount: Int?
    let capacity: Int?
    var startDate: String?
    var endDate: String?
    let manitte: String?
    var didViewRullet: Bool?
    let withFriends: [Friend]?
    let historyWithManitto: [Letter]?
    let historyWithManitte: [Letter]?
    let inviteCode: String?
    let individualMission: String?
    let letters: [Letter]?
}

struct Friend: Decodable {
    let colorIndex: Int?
    let name: String?
}
