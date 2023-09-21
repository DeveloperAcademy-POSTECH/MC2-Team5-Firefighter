//
//  NicknameService.swift
//  Manito
//
//  Created by 이성호 on 2023/09/02.
//

import Foundation

protocol NicknameServicable {
    func putUserInfo(nickname: NicknameDTO) async throws -> Int
}

final class NicknameService: NicknameServicable {
    
    private let repository: SettingRepository
    
    init(repository: SettingRepository) {
        self.repository = repository
    }
    
    func putUserInfo(nickname: NicknameDTO) async throws -> Int {
        do {
            let statusCode = try await self.repository.putUserInfo(nickname: nickname)
            return statusCode
        } catch NetworkError.serverError {
            throw NetworkError.serverError
        } catch NetworkError.clientError(let message) {
            throw NetworkError.clientError(message: message)
        }
    }
}
