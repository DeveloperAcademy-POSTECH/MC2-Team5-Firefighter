//
//  DetailWaitAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/08/27.
//

import Foundation

struct DetailWaitAPI: DetailWaitProtocol {
    private let apiService: APIService
    private let environment: APIEnvironment
    
    init(apiService: APIService, environment: APIEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }

    func getWithFriend(roomId: String) async throws -> FriendList? {
        let request = DetailWaitEndPoint
            .fetchWithFriend(roomId: roomId)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
    
    func getWaitingRoomInfo(roomId: String) async throws -> Room? {
        let request = DetailWaitEndPoint
            .fetchWaitingRoomInfo(roomId: roomId)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }

    func startManitto(roomId: String) async throws -> String? {
        let request = DetailWaitEndPoint
            .patchStartManitto(roomId: roomId)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }

    func editRoomInfo(roomId: String, roomInfo: RoomDTO) async throws -> String? {
        let request = DetailWaitEndPoint
            .putRoomInfo(roomId: roomId, roomInfo: roomInfo)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }

    func deleteRoom(roomId: String) async throws -> String? {
        let request = DetailWaitEndPoint
            .deleteRoom(roomId: roomId)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> String? {
        let request = DetailWaitEndPoint
            .deleteLeaveRoom(roomId: roomId)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
