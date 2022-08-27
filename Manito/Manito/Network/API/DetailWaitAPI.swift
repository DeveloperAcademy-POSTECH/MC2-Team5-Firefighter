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
            .getWithFriend(roomId: roomId)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
    
    func getWaitingRoomInfo(roomId: String, state: String) async throws -> Room? {
        let request = DetailWaitEndPoint
            .getWaitingRoomInfo(roomId: roomId, state: state)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }

    func startManitto(roomId: String, state: String) async throws -> String? {
        let request = DetailWaitEndPoint
            .startManitto(roomId: roomId, state: state)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }

    func editRoomInfo(roomId: String, roomInfo: RoomDTO) async throws -> String? {
        let request = DetailWaitEndPoint
            .editRoomInfo(roomId: roomId, roomInfo: roomInfo)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }

    func deleteRoom(roomId: String) async throws -> String? {
        let request = DetailWaitEndPoint
            .deleteRoom(roomId: roomId)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
