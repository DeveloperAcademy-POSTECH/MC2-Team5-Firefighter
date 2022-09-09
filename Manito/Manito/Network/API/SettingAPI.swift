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
    
    func putChangeNickname(body: NicknameDTO) async throws -> String? {
        let request = SettingEndPoint.editUserInfo(nickNameDto: body)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
