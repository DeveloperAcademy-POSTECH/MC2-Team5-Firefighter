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

extension RoomInfoDTO {
    func toRoomInfo() -> RoomInfo {
        let roomInformation = self.roomInformation?.toRoomListItem()
        let participants = self.participants?.toParticipantList()
        return RoomInfo(roomInformation: roomInformation!,
                        participants: participants ?? ParticipantList(count: 0, members: []),
                        manittee: self.manittee ?? UserInfoDTO(id: "", nickname: ""),
                        manitto: self.manitto,
                        invitation: self.invitation ?? InvitationCodeDTO(code: ""),
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
                               members: self.members ?? [])
    }
}

struct InvitationCodeDTO: Decodable {
    let code: String?
}

/// 개별 미션에 대한 정보들을 반환하는 데이터 모델 DTO입니다.
struct IndividualMissionDTO: Decodable, Hashable {
    /// 개별 미션 identifier
    let id: Int?
    /// 개별 미션 내용
    let content: String?
}

struct MessageInfo: Decodable {
    let count: Int?
}
