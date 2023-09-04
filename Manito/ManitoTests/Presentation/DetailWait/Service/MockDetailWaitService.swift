//
//  MockDetailWaitService.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation
@testable import Manito

final class MockDetailWaitService: DetailWaitServicable {
    // FIXME: - network mocking 만들어야함.
    func fetchWaitingRoomInfo(roomId: String) async throws -> Manito.RoomInfoDTO {
        let room = RoomInfoDTO(
            roomInformation: RoomListItemDTO(id: 1, title: "테스트타이틀", state: "PRE", participatingCount: 5, capacity: 5, startDate: "2023.01.01", endDate: "2023.01.05"),
            participants: ParticipantListDTO(count: 5, members: [
                UserInfoDTO(id: "100", nickname: "유저1"),
                UserInfoDTO(id: "200", nickname: "유저2"),
                UserInfoDTO(id: "300", nickname: "유저3"),
                UserInfoDTO(id: "400", nickname: "유저4"),
                UserInfoDTO(id: "500", nickname: "유저5")
            ]),
            manittee: UserInfoDTO(id: "1", nickname: "테스트마니띠"),
            manitto: UserInfoDTO(id: "2", nickname: "테스트마니또"),
            invitation: InvitationCodeDTO(code: "ABCDEF"),
            didViewRoulette: false,
            mission: IndividualMissionDTO(id: 1, content: "테스트미션"),
            admin: false,
            messages: MessageCountInfoDTO(count: 3))
        return room
    }
    
    func patchStartManitto(roomId: String) async throws -> Manito.UserInfoDTO {
        return UserInfoDTO(id: "1", nickname: "테스트마니띠")
    }
    
    func deleteRoom(roomId: String) async throws -> Int {
        return 200
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> Int {
        return 200
    }
}
