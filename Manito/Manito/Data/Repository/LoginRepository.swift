//
//  LoginRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol LoginRepository {
    func dispatchAppleLogin(loginDTO: LoginDTO) async throws -> Login?
}

final class LoginRepositoryImpl: LoginRepository {

    private var provider = Provider<LoginEndPoint>()

    func dispatchAppleLogin(loginDTO: LoginDTO) async throws -> Login? {
        let response = try await self.provider.request(.dispatchAppleLogin(loginDTO: loginDTO))
        return try response.decode()
    }
}
