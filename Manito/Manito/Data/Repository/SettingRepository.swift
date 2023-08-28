//
//  SettingRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol SettingRepository {
    func putUserInfo(nickname: NicknameDTO) async throws -> NicknameDTO
}

final class SettingRepositoryImpl: SettingRepository {

    private var provider = Provider<SettingEndPoint>()

    func putUserInfo(nickname: NicknameDTO) async throws -> NicknameDTO {
        let response = try await self.provider
            .request(.putUserInfo(nickname: nickname))
        return try response.decode()
    }
}
