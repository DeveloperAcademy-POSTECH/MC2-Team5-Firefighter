//
//  RoomParticipationRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol RoomParticipationRepository {
    func dispatchCreateRoom(roomInfo: CreateRoomDTO) async throws -> Int?
    func dispatchVerifyCode(code: String) async throws -> VerificationCode?
    func dispatchJoinRoom(roomId: String, roomDTO: MemberDTO) async throws -> Int
}

final class RoomParticipationRepositoryImpl: RoomParticipationRepository {

    private var provider = Provider<RoomParticipationEndPoint>()

    func dispatchCreateRoom(roomInfo: CreateRoomDTO) async throws -> Int? {
        let response = try await self.provider
            .request(.dispatchCreateRoom(roomInfo: roomInfo))
        return try response.decode()
    }

    func dispatchVerifyCode(code: String) async throws -> VerificationCode? {
        let response = try await self.provider
            .request(.dispatchVerifyCode(code: code))
        return try response.decode()
    }

    func dispatchJoinRoom(roomId: String, roomDTO: MemberDTO) async throws -> Int {
        let response = try await self.provider
            .request(.dispatchJoinRoom(roomId: roomId,
                                       roomDTO: roomDTO))
        return try response.decode()
    }
}
