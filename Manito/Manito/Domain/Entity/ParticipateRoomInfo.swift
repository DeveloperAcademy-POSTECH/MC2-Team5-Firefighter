//
//  ParticipateRoomInfo.swift
//  Manito
//
//  Created by 이성호 on 2023/09/05.
//

import Foundation

struct ParticipateRoomInfo {
    let id: Int
    let title: String
    let capacity: Int
    let participatingCount: Int
    let startDate: String
    let endDate: String
}

extension ParticipateRoomInfo {
    static let emptyRoom = ParticipateRoomInfo(id: 0,
                                        title: "",
                                        capacity: 0,
                                        participatingCount: 0,
                                        startDate: "",
                                        endDate: "")
}
