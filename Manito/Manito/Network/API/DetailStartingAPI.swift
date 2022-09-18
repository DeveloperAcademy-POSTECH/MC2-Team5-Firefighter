//
//  DetailIngAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

struct DetailIngAPI: DetailStartingProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func requestStartingRoomInfo(roomId: String) async throws -> Room? {
        let request = DetailIngEndPoint
            .requestStartingRoomInfo(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func requestWithFriends(roomId: String) async throws -> FriendList? {
        let request = DetailIngEndPoint
            .requestWithFriend(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
}
