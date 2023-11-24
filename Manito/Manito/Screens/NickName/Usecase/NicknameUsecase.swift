//
//  NicknameUsecase.swift
//  Manito
//
//  Created by 이성호 on 2023/09/02.
//

import Foundation

protocol NicknameUsecase {
    func putUserInfo(nickname: NicknameDTO) async throws -> Int
}

final class NicknameUsecaseImpl: NicknameUsecase {
    
    private let repository: SettingRepository
    
    init(repository: SettingRepository) {
        self.repository = repository
    }
    
    func putUserInfo(nickname: NicknameDTO) async throws -> Int {
        do {
            let statusCode = try await self.repository.putUserInfo(nickname: nickname)
            return statusCode
        } catch {
            throw NicknameError.clientError
        }
    }
}
