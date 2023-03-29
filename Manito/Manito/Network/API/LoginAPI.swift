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
    
    func dispatchLogin(dto: LoginDTO) async throws -> Login? {
        let request = LoginEndPoint
            .dispatchLogin(body: dto)
            .createRequest()
        return try await apiService.request(request)
    }
}
