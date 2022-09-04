//
//  MainAPI.swift
//  Manito
//
//  Created by COBY_PRO on 2022/09/01.
//

import Foundation

struct MainAPI: MainProtocol {
    private let apiService: APIService
    private let environment: APIEnvironment
    
    init(apiService: APIService, environment: APIEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }

    func fetchCommonMission() async throws -> DailyMission? {
        let request = MainEndPoint
            .fetchCommonMission
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
    
    func fetchManittoList() async throws -> ParticipatingRooms? {
        let request = MainEndPoint
            .fetchManittoList
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
