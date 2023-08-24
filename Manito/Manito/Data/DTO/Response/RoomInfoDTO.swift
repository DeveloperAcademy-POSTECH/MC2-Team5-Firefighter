//
//  RoomInfoDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct RoomInfoDTO: Decodable {
    let roomInformation: RoomListItemDTO?
    let participants: ParticipantListDTO?
    let manittee: UserInfoDTO?
    let manitto: UserInfoDTO?
    let invitation: InvitationCodeDTO?
    let didViewRoulette: Bool?
    let mission: IndividualMissionDTO?
    let admin: Bool?
    let messages: MessageInfo?

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

struct ParticipantListDTO: Decodable {
    let count: Int?
    let members: [UserInfoDTO]?
}

struct InvitationCodeDTO: Decodable {
    let code: String?
}

struct IndividualMissionDTO: Decodable {
    let id: Int?
    let content: String?
}

struct MessageInfo: Decodable {
    let count: Int?
}
