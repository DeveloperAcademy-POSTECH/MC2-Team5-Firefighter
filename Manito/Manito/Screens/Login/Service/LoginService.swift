//
//  LoginService.swift
//  Manito
//
//  Created by COBY_PRO on 10/24/23.
//

import Foundation

protocol LoginSevicable {
    func dispatchAppleLogin(login: LoginRequestDTO) async throws -> LoginDTO
}

final class LoginService: LoginSevicable {
    
    private let repository: LoginRepository
    
    init(repository: LoginRepository) {
        self.repository = repository
    }
    
    func dispatchAppleLogin(login: LoginRequestDTO) async throws -> LoginDTO {
        do {
            let loginDTO = try await self.repository.dispatchAppleLogin(login: login)
            return loginDTO
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
}
