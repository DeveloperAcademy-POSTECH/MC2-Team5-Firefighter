//
//  DetailWaitAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/08/27.
//

import Foundation

struct DetailWaitAPI: DetailWaitProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }

    func fetchWithFriend(roomId: String) async throws -> FriendList? {
        let request = DetailWaitEndPoint
            .fetchWithFriend(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func fetchWaitingRoomInfo(roomId: String) async throws -> Room? {
        let request = DetailWaitEndPoint
            .fetchWaitingRoomInfo(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }

    func patchStartManitto(roomId: String) async throws -> Manittee? {
        let request = DetailWaitEndPoint
            .patchStartManitto(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }

    func putRoomInfo(roomId: String, roomInfo: RoomDTO) async throws -> Int {
        let request = DetailWaitEndPoint
            .putRoomInfo(roomId: roomId, roomInfo: roomInfo)
            .createRequest()
        return try await apiService.request(request)
    }

    func deleteRoom(roomId: String) async throws -> Int {
        let request = DetailWaitEndPoint
            .deleteRoom(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> Int {
        let request = DetailWaitEndPoint
            .deleteLeaveRoom(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
}
