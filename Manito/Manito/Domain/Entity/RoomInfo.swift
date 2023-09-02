//
//  RoomInfo.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct RoomInfo {
    let roomInformation: RoomListItem
    let participants: ParticipantList
    let manittee: UserInfoDTO
    let manitto: UserInfoDTO?
    let invitation: InvitationCodeDTO
    let didViewRoulette: Bool?
    let mission: IndividualMissionDTO?
    let admin: Bool
    let messages: MessageInfo?
}

extension RoomInfo {
    var userCount: String {
        return "\(participants.count)/\(roomInformation.capacity)"
    }

    var canStart: Bool {
        if let date = roomInformation.startDate.stringToDate {
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
                        manittee: UserInfoDTO(id: "", nickname: ""),
                        manitto: UserInfoDTO(id: "", nickname: ""),
                        invitation: InvitationCodeDTO(code: ""),
                        didViewRoulette: false,
                        mission: nil,
                        admin: false,
                        messages: nil)
    }()
}
