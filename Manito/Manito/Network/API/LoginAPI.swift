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
    
    func dispatchLogin(identityToken: String, fcmToken: String) async throws -> Login? {
        let request = LoginEndPoint
            .dispatchLogin(loginDTO: LoginDTO(identityToken: identityToken, fcmToken: fcmToken))
            .createRequest()
        return try await apiService.request(request)
    }
}
