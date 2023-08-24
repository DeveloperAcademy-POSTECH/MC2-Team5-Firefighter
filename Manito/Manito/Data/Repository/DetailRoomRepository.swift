//
//  DetailRoomRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol DetailRoomRepository {
    func fetchWithFriend(roomId: String) async throws -> FriendList?
    func fetchRoomInfo(roomId: String) async throws -> Room?
    func fetchResetMission(roomId: String) async throws -> MissionDTO?
    func fetchMemory(roomId: String) async throws -> Memory?
    func patchStartManitto(roomId: String) async throws -> Manittee?
    func patchEditMission(roomId: String, body: MissionDTO) async throws -> MissionDTO?
    func putRoomInfo(roomId: String, roomInfo: RoomDTO) async throws -> Int
    func deleteRoom(roomId: String) async throws -> Int
    func deleteLeaveRoom(roomId: String) async throws -> Int
}

final class DetailRoomRepositoryImpl: DetailRoomRepository {

    private var provider = Provider<DetailRoomEndPoint>()

    func fetchWithFriend(roomId: String) async throws -> FriendList? {
        let response = try await self.provider.request(.fetchWithFriend(roomId: roomId))
        return try response.decode()
    }

    func fetchRoomInfo(roomId: String) async throws -> Room? {
        let response = try await self.provider.request(.fetchRoomInfo(roomId: roomId))
        return try response.decode()
    }

    func fetchResetMission(roomId: String) async throws -> MissionDTO? {
        let response = try await self.provider.request(.fetchResetMission(roomId: roomId))
        return try response.decode()
    }

    func fetchMemory(roomId: String) async throws -> Memory? {
        let response = try await self.provider.request(.fetchMemory(roomId: roomId))
        return try response.decode()
    }

    func patchStartManitto(roomId: String) async throws -> Manittee? {
        let response = try await self.provider.request(.patchStartManitto(roomId: roomId))
        return try response.decode()
    }

    func patchEditMission(roomId: String, body: MissionDTO) async throws -> MissionDTO? {
        let response = try await self.provider.request(.patchEditMission(roomId: roomId, body: body))
        return try response.decode()
    }

    func putRoomInfo(roomId: String, roomInfo: RoomDTO) async throws -> Int {
        let response = try await self.provider.request(.putRoomInfo(roomId: roomId, roomInfo: roomInfo))
        return try response.decode()
    }

    func deleteRoom(roomId: String) async throws -> Int {
        let response = try await self.provider.request(.deleteRoom(roomId: roomId))
        return try response.decode()
    }

    func deleteLeaveRoom(roomId: String) async throws -> Int {
        let response = try await self.provider.request(.deleteLeaveRoom(roomId: roomId))
        return try response.decode()
    }
}
