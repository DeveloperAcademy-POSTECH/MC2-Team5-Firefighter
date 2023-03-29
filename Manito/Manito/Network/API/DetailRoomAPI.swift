//
//  DetailRoomAPI.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/29.
//

import Foundation

struct DetailRoomAPI: DetailRoomProtocol {
    private let apiService: Requestable

    init(apiService: Requestable) {
        self.apiService = apiService
    }

    func fetchStartingRoomInfo(roomId: String) async throws -> Room? {
        let request = DetailRoomEndPoint
            .fetchStartingRoomInfo(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }

    func fetchDoneRoomInfo(roomId: String) async throws -> Room? {
        let request = DetailRoomEndPoint
            .fetchDoneRoomInfo(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }

    func fetchWithFriend(roomId: String) async throws -> FriendList? {
        let request = DetailRoomEndPoint
            .fetchWithFriend(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }

    func fetchMemory(roomId: String) async throws -> Memory? {
        let request = DetailRoomEndPoint
            .fetchMemory(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }

    func deleteRoomByMember(roomId: String) async throws -> Int {
        let request = DetailRoomEndPoint
            .deleteRoomByMember(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }

    func deleteRoomByOwner(roomId: String) async throws -> Int {
        let request = DetailRoomEndPoint
            .deleteRoomByOwner(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
}
