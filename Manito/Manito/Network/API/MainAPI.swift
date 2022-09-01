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

    func getCommonMission() async throws -> String? {
        let request = MainEndPoint
            .getCommonMission
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
    
    func getManittoList() async throws -> [Room]? {
        let request = MainEndPoint
            .getManittoList
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
