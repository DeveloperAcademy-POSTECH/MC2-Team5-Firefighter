//
//  DetailRoomRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol DetailRoomRepository {
    func fetchWithFriend(roomId: String) async throws -> FriendListDTO
    func fetchRoomInfo(roomId: String) async throws -> RoomInfoDTO
    func fetchResetMission(roomId: String) async throws -> IndividualMissionDTO
    func fetchMemory(roomId: String) async throws -> MemoryDTO
    func patchStartManitto(roomId: String) async throws -> UserInfoDTO
    func patchEditMission(roomId: String, mission: EditedMissionRequestDTO) async throws -> IndividualMissionDTO
    func putRoomInfo(roomId: String, roomInfo: CreatedRoomInfoRequestDTO) async throws -> Int
    func deleteRoom(roomId: String) async throws -> Int
    func deleteLeaveRoom(roomId: String) async throws -> Int
}

final class DetailRoomRepositoryImpl: DetailRoomRepository {

    private var provider = Provider<DetailRoomEndPoint>()

    func fetchWithFriend(roomId: String) async throws -> FriendListDTO {
        let response = try await self.provider
            .request(.fetchWithFriend(roomId: roomId))
        return try response.decode()
    }

    func fetchRoomInfo(roomId: String) async throws -> RoomInfoDTO {
        let response = try await self.provider
            .request(.fetchRoomInfo(roomId: roomId))
        return try response.decode()
    }

    func fetchResetMission(roomId: String) async throws -> IndividualMissionDTO {
        let response = try await self.provider
            .request(.fetchResetMission(roomId: roomId))
        return try response.decode()
    }

    func fetchMemory(roomId: String) async throws -> MemoryDTO {
        let response = try await self.provider
            .request(.fetchMemory(roomId: roomId))
        return try response.decode()
    }

    func patchStartManitto(roomId: String) async throws -> UserInfoDTO {
        let response = try await self.provider
            .request(.patchStartManitto(roomId: roomId))
        return try response.decode()
    }

    func patchEditMission(roomId: String, mission: EditedMissionRequestDTO) async throws -> IndividualMissionDTO {
        let response = try await self.provider
            .request(.patchEditMission(roomId: roomId,
                                       mission: mission))
        return try response.decode()
    }

    func putRoomInfo(roomId: String, roomInfo: CreatedRoomInfoRequestDTO) async throws -> Int {
        let response = try await self.provider
            .request(.putRoomInfo(roomId: roomId,
                                  roomInfo: roomInfo))
        return response.statusCode
    }

    func deleteRoom(roomId: String) async throws -> Int {
        let response = try await self.provider
            .request(.deleteRoom(roomId: roomId))
        return response.statusCode
    }

    func deleteLeaveRoom(roomId: String) async throws -> Int {
        let response = try await self.provider
            .request(.deleteLeaveRoom(roomId: roomId))
        return response.statusCode
    }
}
