//
//  SettingService.swift
//  Manito
//
//  Created by 이성호 on 2023/09/01.
//

import Foundation

protocol SettingServicable {
    func deleteUser() async throws -> Int
}

final class SettingService: SettingServicable {
    
    private let repository: SettingRepository
    
    init(repository: SettingRepository) {
        self.repository = repository
    }
    
    func deleteUser() async throws -> Int {
        do {
            let statusCode = try await self.repository.deleteMember()
            return statusCode
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
}
