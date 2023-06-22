//
//  Letter.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/12.
//

import Foundation

struct Letter: Codable {
    var count: Int?
    var manittee: Manitte?
    var messages: [Message]
}

struct Manitte: Codable {
    var id: String?
    var nickname: String?
}

struct Message: Codable, Hashable {
    var id: Int?
    var content: String?
    var imageUrl: String?
    var createdDate: String?
    var missionInfo: Mission?

    var isToday: Bool {
        return Date().letterDateToString == createdDate
    }
    
    var date: String {
        guard let createdDate = createdDate else { return "" }
        return self.isToday ? "오늘" : createdDate
    }

    var mission: String? {
        guard let mission = missionInfo?.content else { return nil }

        return "\(date)의 개별미션\n[\(mission)]"
    }
}
