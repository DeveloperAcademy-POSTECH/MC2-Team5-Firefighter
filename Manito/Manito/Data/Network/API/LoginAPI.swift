//
//  LoginAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

struct LoginAPI: LoginProtocol {
    private let apiService: Requestable

    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func dispatchAppleLogin(dto: LoginDTO) async throws -> Login? {
        let request = LoginEndPoint
            .dispatchAppleLogin(body: dto)
            .createRequest()
        return try await apiService.request(request)
    }
}
