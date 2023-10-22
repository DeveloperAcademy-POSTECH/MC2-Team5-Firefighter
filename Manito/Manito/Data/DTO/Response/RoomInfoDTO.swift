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

extension RoomInfoDTO: Equatable {
    static let testDummyRoomDTO = RoomInfoDTO(
        roomInformation: RoomListItemDTO.testDummyRoomListItemDTO,
        participants: ParticipantListDTO.testDummyParticipantListDTO,
        manittee: UserInfoDTO.testDummyUserManittee,
        manitto: UserInfoDTO.testDummyUserManitto,
        invitation: InvitationCodeDTO.testDummyInvitationCodeDTO,
        didViewRoulette: false,
        mission: IndividualMissionDTO.testDummyIndividualMissionDTO,
        admin: false,
        messages: MessageCountInfoDTO.testDummyMessageInfoDTO
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

extension ParticipantListDTO: Equatable {
    static let testDummyParticipantListDTO = ParticipantListDTO(
        count: 5,
        members: UserInfoDTO.testDummyUserList
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

extension InvitationCodeDTO: Equatable {
    static let testDummyInvitationCodeDTO = InvitationCodeDTO(code: "ABCDEF")
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

extension IndividualMissionDTO: Equatable {
    static let testDummyIndividualMissionDTO = IndividualMissionDTO(id: 1, content: "테스트미션")
}

struct MessageCountInfoDTO: Decodable {
    let count: Int?
}

extension MessageCountInfoDTO {
    func toMessageCountInfo() -> MessageCountInfo {
        return MessageCountInfo(count: self.count ?? 0)
    }
}

extension MessageCountInfoDTO: Equatable {
    static let testDummyMessageInfoDTO = MessageCountInfoDTO(count: 3)
}
