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
    let room: RoomInfo?
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
           let capacity = room?.capacity {
            return "\(count)/\(capacity)"
        } else {
            return ""
        }
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
