//
//  LoginUsecase.swift
//  Manito
//
//  Created by COBY_PRO on 11/9/23.
//

import Foundation

protocol LoginUsecase {
    func dispatchAppleLogin(login: LoginRequestDTO) async throws -> Login
}

final class LoginUsecaseImpl: LoginUsecase {
    
    // MARK: - property
    
    private let repository: LoginRepository
    
    // MARK: - init
    
    init(repository: LoginRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func dispatchAppleLogin(login: LoginRequestDTO) async throws -> Login {
        do {
            let loginDTO = try await self.repository.dispatchAppleLogin(login: login)
            return loginDTO.toLogin()
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
}
