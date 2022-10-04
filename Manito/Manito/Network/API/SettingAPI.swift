//
//  SettingAPI.swift
//  Manito
//
//  Created by 이성호 on 2022/09/07.
//

import Foundation

struct SettingAPI: SettingProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func putChangeNickname(body: NicknameDTO) async throws -> String? {
        let request = SettingEndPoint
            .editUserInfo(nickNameDto: body)
            .createRequest()
        return try await apiService.request(request)
    }
}
