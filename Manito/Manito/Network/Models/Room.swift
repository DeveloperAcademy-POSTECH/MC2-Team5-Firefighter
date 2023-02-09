//
//  Room.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

struct ParticipatingRooms: Decodable {
    let participatingRooms: [ParticipatingRoom]?
}

struct ParticipatingRoom: Decodable {
    let id: Int?
    let title: String?
    var state: String?
    let participatingCount, capacity: Int?
    let startDate, endDate: String?
}

struct Room: Decodable {
    let roomInformation: RoomInfo?
    let participants: Participants?
    let manittee: Manittee?
    let manitto: Manitto?
    let invitation: Invitation?
    var didViewRoulette: Bool?
    let mission: Mission?
    let admin: Bool?
    let messages: Message1?
    
    var userCount: String {
        if let count = participants?.count,
           let capacity = roomInformation?.capacity {
            return "\(count)/\(capacity)"
        } else {
            return ""
        }
    }
    
    var canStart: Bool {
        if let count = participants?.count,
           let date = roomInformation?.startDate?.stringToDate {
            let isMinimumUserCount = count >= 4
            return isMinimumUserCount && date.isToday
        } else {
            return false
        }
    }
    
    var roomDTO: RoomDTO {
        if let roomInformation {
            let dto = RoomDTO(title: roomInformation.title ?? "",
                              capacity: roomInformation.capacity ?? 0,
                              startDate: roomInformation.startDate ?? "",
                              endDate: roomInformation.endDate ?? "")
            return dto
        } else {
            return RoomDTO(title: "", capacity: 0, startDate: "", endDate: "")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case roomInformation = "room"
        case participants
        case manittee
        case manitto
        case invitation
        case didViewRoulette
        case mission
        case admin
        case messages
    }
}

struct Friend: Decodable {
    let colorIndex: Int?
    let name: String?
}

// MARK: - Participants
struct Participants: Decodable {
    let count: Int?
    let members: [User]?
    
    var membersNickname: [String] {
        if let nicknames = members {
            return nicknames.map { $0.nickname ?? "" }
        } else {
            return []
        }
    }
}

// MARK: - Member
struct User: Decodable {
    let id, nickname: String?
}

// MARK: - Room
struct RoomInfo: Decodable {
    let id, capacity: Int?
    let title, startDate, endDate, state: String?
    
    var dateRange: String {
        if let startDate,
           let endDate {
            return startDate + " ~ " + endDate
        } else {
            return ""
        }
    }
    
    var isAlreadyPastDate: Bool {
        if let date = startDate?.stringToDate {
            return date.distance(to: Date()) > 86400
        } else {
            return false
        }
    }
    
    var isStart: Bool {
        if let date = startDate?.stringToDate {
            let canStart = date.isToday
            return canStart
        } else {
            return false
        }
    }
}

struct Mission: Codable {
    let id: Int?
    let content: String?
}

struct Invitation: Decodable {
    let code: String?
}

struct Message1: Decodable {
    let count: Int?
}

struct Manittee: Decodable {
    let nickname: String?
}

struct Manitto: Decodable {
    let nickname: String?
}
