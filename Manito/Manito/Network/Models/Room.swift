//
//  Room.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

struct ParticipatingRooms: Decodable {
    let participatingRooms: [Room]
}

struct Room: Decodable {
    let room: RoomInfo?
    let participants: Participants?
    let manittee: Manittee?
    let invitation: Invitation?
    var didViewRoulette: Bool?
    let mission: Mission?
    let admin: Bool?
    let messages: Message1?
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
