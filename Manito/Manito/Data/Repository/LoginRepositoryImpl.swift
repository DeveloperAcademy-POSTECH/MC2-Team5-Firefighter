//
//  LoginRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

final class LoginRepositoryImpl: LoginRepository {

    private var provider = Provider<LoginEndPoint>()

    func dispatchAppleLogin(login: LoginRequestDTO) async throws -> LoginDTO {
        let response = try await self.provider
            .request(.dispatchAppleLogin(login: login))
        return try response.decode()
    }
}
