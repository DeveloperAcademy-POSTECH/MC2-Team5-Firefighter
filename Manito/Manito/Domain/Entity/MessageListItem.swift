//
//  MessageListItem.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct MessageListItem: Hashable {
    let id: Int
    let content: String?
    let imageUrl: String?
    let createdDate: String
    let missionInfo: IndividualMissionDTO?
    let canReport: Bool

    var isToday: Bool {
        return Date().letterDateToString == createdDate
    }

    var date: String {
        return self.isToday ? "오늘" : createdDate
    }

    var mission: String? {
        guard let mission = missionInfo?.content else { return nil }

        return "\(date)의 개별미션\n[\(mission)]"
    }
}
