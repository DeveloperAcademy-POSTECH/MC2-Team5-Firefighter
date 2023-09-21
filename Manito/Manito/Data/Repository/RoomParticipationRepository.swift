//
//  RoomParticipationRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol RoomParticipationRepository {
    func dispatchCreateRoom(room: CreatedRoomRequestDTO) async throws -> Int
    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO
    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int
}

final class RoomParticipationRepositoryImpl: RoomParticipationRepository {

    private var provider = Provider<RoomParticipationEndPoint>()

    func dispatchCreateRoom(room: CreatedRoomRequestDTO) async throws -> Int {
        let response = try await self.provider
            .request(.dispatchCreateRoom(room: room))
        let location = response.response?.allHeaderFields["Location"] as? String
        let roomId = Int(location?.split(separator: "/").last ?? "-1") ?? -1
        return roomId
    }

    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO {
        let response = try await self.provider
            .request(.dispatchVerifyCode(code: code))
        return try response.decode()
    }

    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int {
        let response = try await self.provider
            .request(.dispatchJoinRoom(roomId: roomId,
                                       member: member))
        return response.statusCode
    }
}
