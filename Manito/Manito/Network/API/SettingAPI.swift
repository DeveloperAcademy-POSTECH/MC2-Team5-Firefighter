//
//  SettingAPI.swift
//  Manito
//
//  Created by 이성호 on 2022/09/07.
//

import Foundation

struct SettingAPI: SettingProtocol {
    
    private let apiService: APIService
    private let environment: APIEnvironment
    
    init(apiService: APIService, environment: APIEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }
    
    func putNickname(body: String) async throws -> String? {
        let request = SettingEndPoint.editUserInfo(nickName: body).createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
