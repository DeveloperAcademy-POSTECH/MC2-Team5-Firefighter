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
        let mission = self.mission?.toIndividualMission()
        let messages = self.messages?.toMessageCountInfo()
        return RoomInfo(roomInformation: roomInformation!,
                        participants: participants ?? ParticipantList(count: 0, members: []),
                        manittee: manitteeUserInfo ?? UserInfo(id: "", nickname: ""),
                        manitto: manittoUserInfo,
                        invitation: invitation ?? InvitationCode(code: ""),
                        didViewRoulette: self.didViewRoulette,
                        mission: mission ?? IndividualMission(id: 0, content: ""),
                        admin: self.admin ?? false,
                        messages: messages ?? MessageCountInfo(count: 0))
    }
}

extension RoomInfoDTO {
    static let testRoomDTO = RoomInfoDTO(
        roomInformation: RoomListItemDTO.testRoomListItemDTO,
        participants: ParticipantListDTO.testParticipantListDTO,
        manittee: UserInfoDTO.testUserManittee,
        manitto: UserInfoDTO.testUserManitto,
        invitation: InvitationCodeDTO.testInvitationCodeDTO,
        didViewRoulette: false,
        mission: IndividualMissionDTO.testIndividualMissionDTO,
        admin: false,
        messages: MessageCountInfoDTO.testMessageInfoDTO
    )
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

extension ParticipantListDTO {
    static let testParticipantListDTO = ParticipantListDTO(
        count: 5,
        members: UserInfoDTO.testUserList
    )
}

struct InvitationCodeDTO: Decodable {
    let code: String?
}

extension InvitationCodeDTO {
    func toInvitationCode() -> InvitationCode {
        return InvitationCode(code: self.code ?? "")
    }
}

extension InvitationCodeDTO {
    static let testInvitationCodeDTO = InvitationCodeDTO(code: "ABCDEF")
}

/// 개별 미션에 대한 정보들을 반환하는 데이터 모델 DTO입니다.
struct IndividualMissionDTO: Decodable, Hashable {
    /// 개별 미션 identifier
    let id: Int?
    /// 개별 미션 내용
    let content: String?
}

extension IndividualMissionDTO {
    func toIndividualMission() -> IndividualMission {
        return IndividualMission(id: self.id ?? 0, content: self.content ?? "")
    }
}

extension IndividualMissionDTO {
    static let testIndividualMissionDTO = IndividualMissionDTO(id: 1, content: "테스트미션")
}

struct MessageCountInfoDTO: Decodable {
    let count: Int?
}

extension MessageCountInfoDTO: Equatable {
    func toMessageCountInfo() -> MessageCountInfo {
        return MessageCountInfo(count: self.count ?? 0)
    }
}

extension MessageCountInfoDTO {
    static let testMessageInfoDTO = MessageCountInfoDTO(count: 3)
}
