//
//  LoginRepository.swift
//  Manito
//
//  Created by 이성호 on 10/31/23.
//

import Foundation

protocol LoginRepository {
    func dispatchAppleLogin(login: LoginRequestDTO) async throws -> LoginDTO
}
