//
//  RoomParticipationRepository.swift
//  Manito
//
//  Created by 이성호 on 10/31/23.
//

import Foundation

protocol RoomParticipationRepository {
    func dispatchCreateRoom(room: CreatedRoomRequestDTO) async throws -> Int
    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO
    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int
}
