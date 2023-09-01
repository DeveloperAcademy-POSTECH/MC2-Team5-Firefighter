//
//  SettingRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol SettingRepository {
    func putUserInfo(nickname: NicknameDTO) async throws -> Int
    func deleteMember() async throws -> Int
}

final class SettingRepositoryImpl: SettingRepository {

    private var provider = Provider<SettingEndPoint>()

    func putUserInfo(nickname: NicknameDTO) async throws -> Int {
        let response = try await self.provider
            .request(.putUserInfo(nickname: nickname))
        return response.statusCode
    }
    
    func deleteMember() async throws -> Int {
        let response = try await self.provider
            .request(.deleteUser)
        return response.statusCode
    }
}
