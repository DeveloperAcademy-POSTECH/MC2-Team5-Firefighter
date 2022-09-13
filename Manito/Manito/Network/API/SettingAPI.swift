//
//  SettingAPI.swift
//  Manito
//
//  Created by 이성호 on 2022/09/07.
//

import Foundation

struct SettingAPI: SettingProtocol {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func putChangeNickname(body: NicknameDTO) async throws -> String? {
        let request = SettingEndPoint.editUserInfo(nickNameDto: body)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
