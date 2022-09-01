//
//  Room.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

struct Room: Decodable {
    let room: RoomInfo?
    let capacity: Int?
    var startDate: String?
    var endDate: String?
    let state: String?
    let participants: Participants?
    let manittee: String?
    let invitation: Invitation?
    var didViewRoulette: Bool?
    let mission: String?
    let admin: Bool?
    let messages: Int?
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
    let id: Int?
    let title, startDate, endDate, state: String?
}

struct Invitation: Decodable {
    let code: String?
}
