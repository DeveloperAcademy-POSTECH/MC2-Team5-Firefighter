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
    let messages: MessageCountInfoDTO?

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

extension RoomInfoDTO {
    func toRoomInfo() -> RoomInfo {
        let roomInformation = self.roomInformation?.toRoomListItem()
        let participants = self.participants?.toParticipantList()
        let manitteeUserInfo = self.manittee?.toUserInfo()
        let manittoUserInfo = self.manitto?.toUserInfo()
        let invitation = self.invitation?.toInvitationCode()
        return RoomInfo(roomInformation: roomInformation!,
                        participants: participants ?? ParticipantList(count: 0, members: []),
                        manittee: manitteeUserInfo ?? UserInfo(id: "", nickname: ""),
                        manitto: manittoUserInfo,
                        invitation: invitation ?? InvitationCode(code: ""),
                        didViewRoulette: self.didViewRoulette,
                        mission: self.mission,
                        admin: self.admin ?? false,
                        messages: self.messages)
    }
}

struct ParticipantListDTO: Decodable {
    let count: Int?
    let members: [UserInfoDTO]?
}

extension ParticipantListDTO {
    func toParticipantList() -> ParticipantList {
        return ParticipantList(count: self.count ?? 0,
                               members: self.members?.compactMap { $0.toUserInfo() } ?? [])
    }
}

struct InvitationCodeDTO: Decodable {
    let code: String?
}

extension InvitationCodeDTO {
    func toInvitationCode() -> InvitationCode {
        return InvitationCode(code: self.code ?? "")
    }
}

struct IndividualMissionDTO: Decodable, Hashable {
    let id: Int?
    let content: String?
}

extension IndividualMissionDTO: Equatable {
    static let testIndividualMissionDTO = IndividualMissionDTO(id: 1, content: "테스트미션")
}

struct MessageCountInfoDTO: Decodable {
    let count: Int?
}

extension MessageCountInfoDTO: Equatable {
    static let testMessageInfo = MessageCountInfoDTO(count: 3)
}
