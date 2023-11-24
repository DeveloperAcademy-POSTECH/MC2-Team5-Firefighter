//
//  DetailRoomRepository.swift
//  Manito
//
//  Created by 이성호 on 10/31/23.
//

import Foundation

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
