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
    let id: Int?
    let title: String?
    let state: String?
    let participatingCount: Int?
    let capacity: Int?
    var startDate: String?
    var endDate: String?
    let manittee: String?
    var didViewRoulette: Bool?
    let withFriends: [Friend]?
    let historyWithManitto: [Letter]?
    let historyWithManitte: [Letter]?
    let inviteCode: String?
    let mission: String?
    let letters: [Letter]?
    let admin: Bool?
    let message: Int?
    let room: Room1?
    let participants: Participants?
}

struct Friend: Decodable {
    let colorIndex: Int?
    let name: String?
}

struct RoomInfo: Codable {
    let room: Room1?
    let participants: Participants?
    let manittee, mission: String?
    let didViewRoulette, admin: Bool?
    let messages: Int?
}

// MARK: - Participants
struct Participants: Codable {
    let count: Int?
    let members: [Member1]?
}

// MARK: - Member
struct Member1: Codable {
    let id, nickname: String?
}

// MARK: - Room
struct Room1: Codable {
    let id: Int?
    let title, startDate, endDate, state: String?
}
