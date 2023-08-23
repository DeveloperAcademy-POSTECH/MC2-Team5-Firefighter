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

struct ParticipatingRoom: Decodable, Equatable {
    let id: Int?
    let title: String?
    var state: String?
    let participatingCount, capacity: Int?
    let startDate, endDate: String?
}

struct Room: Decodable, Equatable {
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.roomInformation == rhs.roomInformation &&
        lhs.participants == rhs.participants &&
        lhs.manittee == rhs.manittee &&
        lhs.manitto == rhs.manitto &&
        lhs.invitation == rhs.invitation &&
        lhs.didViewRoulette == rhs.didViewRoulette &&
        lhs.mission == rhs.mission &&
        lhs.admin == rhs.admin &&
        lhs.messages == rhs.messages
    }
    
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
           let date = roomInformation?.startDate?.stringToDate,
           let isAdmin = admin {
            let isMinimumUserCount = count >= 4
            return isMinimumUserCount && date.isToday && isAdmin
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

extension Room {
    static let emptyRoom = Room(
            roomInformation: nil,
            participants: nil,
            manittee: nil,
            manitto: nil,
            invitation: nil,
            mission: nil,
            admin: nil,
            messages: nil)
    
    static let testRoom = Room(
        roomInformation: RoomInfo.testRoomInfo,
        participants: Participants.testParticipants,
        manittee: Manittee.testManittee,
        manitto: Manitto.testManitto,
        invitation: Invitation.testInvitation,
        didViewRoulette: false,
        mission: Mission.testMission,
        admin: false,
        messages: Message1.testMessage)
}

struct Friend: Decodable {
    let colorIndex: Int?
    let name: String?
}

// MARK: - Participants
struct Participants: Decodable, Equatable {
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

extension Participants {
    static let testParticipants = Participants(
        count: 5,
        members: User.testUserList)
}

// MARK: - User
struct User: Decodable, Equatable {
    let id, nickname: String?
}

extension User {
    static let testUser = User(
        id: "100", nickname: "유저1")
    static let testUserList = [
        User(id: "100", nickname: "유저1"),
        User(id: "200", nickname: "유저2"),
        User(id: "300", nickname: "유저3"),
        User(id: "400", nickname: "유저4"),
        User(id: "500", nickname: "유저5")
    ]
}

// MARK: - Room
struct RoomInfo: Decodable, Equatable {
    let id, capacity: Int?
    let title, startDate, endDate, state: String?
    
    var dateRangeText: String {
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
            let isStartDate = date.distance(to: Date()) < 86400
            let isPast = date.distance(to: Date()) > 86400
            return !isPast && isStartDate
        } else {
            return false
        }
    }
    
    var isStartDatePast: Bool {
        guard let startDate = self.startDate?.stringToDate else { return true }
        return startDate.isPast
    }
    
    var dateRange: (startDate: String, endDate: String) {
        let fiveDaysInterval: TimeInterval = 86400 * 4
        let startDate: String = isStartDatePast ? Date().dateToString : self.startDate ?? ""
        let endDate: String = isStartDatePast ? (Date() + fiveDaysInterval).dateToString : self.endDate ?? ""

        return (startDate, endDate)
    }
}

extension RoomInfo {
    static let testRoomInfo = RoomInfo(
        id: 1,
        capacity: 5,
        title: "테스트타이틀",
        startDate: "2023.01.01",
        endDate: "2023.01.05",
        state: "PRE")
}

// MARK: - Mission
struct Mission: Codable, Equatable, Hashable {
    let id: Int?
    let content: String?
}

extension Mission {
    static let testMission = Mission(id: 1, content: "테스트미션")
}

// MARK: - Invitation
struct Invitation: Decodable, Equatable {
    let code: String?
}

extension Invitation {
    static let testInvitation = Invitation(code: "ABCDEF")
}

// MARK: - Message1
struct Message1: Decodable, Equatable {
    let count: Int?
}

extension Message1 {
    static let testMessage = Message1(count: 3)
}

// MARK: - Manittee
struct Manittee: Decodable, Equatable {
    let nickname: String?
}

extension Manittee {
    static let testManittee = Manittee(nickname: "테스트마니띠")
}

// MARK: - Manitto
struct Manitto: Decodable, Equatable {
    let nickname: String?
}

extension Manitto {
    static let testManitto = Manitto(nickname: "테스트마니또")
}
