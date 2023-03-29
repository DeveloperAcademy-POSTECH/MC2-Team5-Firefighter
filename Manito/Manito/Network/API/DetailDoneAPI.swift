//
//  DetailEndAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

struct DetailDoneAPI: DetailDoneProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func fetchMemory(roomId: String) async throws -> Memory? {
        let request = DetailDoneEndPoint
            .fetchMemory(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func fetchDoneRoomInfo(roomId: String) async throws -> Room? {
        let request = DetailDoneEndPoint
            .fetchDoneRoomInfo(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func fetchWithFriend(roomId: String) async throws -> FriendList? {
        let request = DetailDoneEndPoint
            .fetchWithFriend(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func deleteRoomByMember(roomId: String) async throws -> Int {
        let request = DetailDoneEndPoint
            .deleteRoomByMember(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func deleteRoomByOwner(roomId: String) async throws -> Int {
        let request = DetailDoneEndPoint
            .deleteRoomByOwner(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
}
