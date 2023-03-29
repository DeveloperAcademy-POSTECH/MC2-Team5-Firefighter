//
//  DetailIngAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

struct DetailIngAPI: DetailIngProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func fetchStartingRoomInfo(roomId: String) async throws -> Room? {
        let request = DetailIngEndPoint
            .fetchStartingRoomInfo(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func fetchWithFriends(roomId: String) async throws -> FriendList? {
        let request = DetailIngEndPoint
            .fetchWithFriend(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
}
