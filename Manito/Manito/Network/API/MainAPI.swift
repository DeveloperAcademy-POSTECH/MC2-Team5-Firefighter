//
//  MainAPI.swift
//  Manito
//
//  Created by COBY_PRO on 2022/09/01.
//

import Foundation

struct MainAPI: MainProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }

    func fetchCommonMission() async throws -> DailyMission? {
        let request = MainEndPoint
            .fetchCommonMission
            .createRequest()
        return try await apiService.request(request)
    }
    
    func fetchRooms() async throws -> ParticipatingRooms? {
        let request = MainEndPoint
            .fetchRooms
            .createRequest()
        return try await apiService.request(request)
    }
}
