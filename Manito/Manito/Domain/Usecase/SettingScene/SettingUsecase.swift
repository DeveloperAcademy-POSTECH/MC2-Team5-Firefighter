//
//  SettingUsecase.swift
//  Manito
//
//  Created by 이성호 on 2023/09/01.
//

import Foundation

protocol SettingUsecase {
    func deleteUser() async throws -> Int
}

final class SettingUsecaseImpl: SettingUsecase {
    
    // MARK: - property
    
    private let repository: SettingRepository
    
    // MARK: - init
    
    init(repository: SettingRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func deleteUser() async throws -> Int {
        do {
            let statusCode = try await self.repository.deleteMember()
            return statusCode
        } catch {
            throw SettingError.clientError
        }
    }
}
