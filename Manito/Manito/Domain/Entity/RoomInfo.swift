//
//  RoomInfo.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 대기방, 진행중, 완료 상태의 방의 상세 정보를 나타내는
/// 데이터 모델 Entity 입니다.
///
struct RoomInfo {
    /// 방의 이름과 상태, 참여 인원, 날짜가 포함된 Entity
    let roomInformation: RoomListItem
    /// 참여 인원 Entity
    let participants: ParticipantList
    /// 마니띠 Entity
    let manittee: UserInfo
    /// 마니또 Entity (옵션)
    let manitto: UserInfo?
    /// 초대 코드 Entity
    let invitation: InvitationCode
    /// 마니또 시작시에 단 한번 표시되는
    /// 레버 GIF를 봤는지에 대한 Bool 값 (옵션)
    let didViewRoulette: Bool?
    /// 개별 미션 Entity (옵션)
    let mission: IndividualMission?
    /// 방장 여부
    let admin: Bool
    /// 진행중 상태일 때 쪽지함 뱃지 형식으로 표시 되는 Entity (옵션)
    let messages: MessageCountInfo?
}

extension RoomInfo {
    /// 현재 인원 / 최대 인원 형식으로 반환
    var userCount: String {
        return "\(participants.count)/\(roomInformation.capacity)"
    }
    
    /// 마니또 시작 가능한 상태인지
    var canStart: Bool {
        if let date = roomInformation.startDate.toDefaultDate {
            let isMinimumUserCount = participants.count >= 4
            return isMinimumUserCount && date.isToday && admin
        } else {
            return false
        }
    }
    
    func toRoomListItem() -> RoomListItem {
        return RoomListItem(id: roomInformation.id,
                            title: roomInformation.title,
                            state: roomInformation.state.rawValue,
                            participatingCount: participants.count,
                            capacity: roomInformation.capacity,
                            startDate: roomInformation.startDate,
                            endDate: roomInformation.endDate)
    }

    static let emptyRoom: RoomInfo = {
        let roomList = RoomListItem(id: 0,
                                    title: "",
                                    state: "",
                                    participatingCount: 0,
                                    capacity: 0,
                                    startDate: "",
                                    endDate: "")
        return RoomInfo(roomInformation: roomList,
                        participants: ParticipantList(count: 0, members: []),
                        manittee: UserInfo(id: "", nickname: ""),
                        manitto: UserInfo(id: "", nickname: ""),
                        invitation: InvitationCode(code: ""),
                        didViewRoulette: false,
                        mission: nil,
                        admin: false,
                        messages: nil)
    }()
}

extension RoomInfo: Equatable {
    static let testRoom = RoomInfo(
        roomInformation: RoomListItem.testRoomListItem,
        participants: ParticipantList.testParticipantList,
        manittee: UserInfo.testUserManittee,
        manitto: UserInfo.testUserManitto,
        invitation: InvitationCode.testInvitationCode,
        didViewRoulette: false,
        mission: IndividualMission.testIndividualMission,
        admin: false,
        messages: MessageCountInfo.testMessageInfo
    )
}
