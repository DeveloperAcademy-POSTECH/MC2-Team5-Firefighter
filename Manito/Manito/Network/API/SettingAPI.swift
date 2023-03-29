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
    
    func putNickname(body: NicknameDTO) async throws -> String? {
        let request = SettingEndPoint
            .putNickname(nickNameDto: body)
            .createRequest()
        return try await apiService.request(request)
    }
}
