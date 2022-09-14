//
//  DetailEndAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

struct DetailDoneAPI: DetailDoneProtocol {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func requestMemory(roomId: String) async throws -> Memory? {
        let request = DetailDoneEndPoint
            .requestMemory(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func requestDoneRoomInfo(roomId: String) async throws -> Room? {
        let request = DetailDoneEndPoint
            .requestDoneRoomInfo(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func requestWithFriends(roomId: String) async throws -> FriendList? {
        let request = DetailDoneEndPoint
            .requestWithFriend(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
}
