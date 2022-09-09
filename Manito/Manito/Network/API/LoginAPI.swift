//
//  LoginAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

struct LoginAPI: LoginProtocol {
    private let apiService: Requestable
    private let environment: APIEnvironment

    init(apiService: Requestable, environment: APIEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }
    
    func dispatchAppleLogin(dto: LoginDTO) async throws -> Login? {
        let request = LoginEndPoint
            .dispatchAppleLogin(body: dto)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
    
    func putRefreshToken(dto: RefreshToken) async throws -> RefreshToken? {
        let request = LoginEndPoint
            .putRefreshToken(body: dto)
            .createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
