//
//  SettingRepository.swift
//  Manito
//
//  Created by 이성호 on 10/31/23.
//

import Foundation

protocol SettingRepository {
    func putUserInfo(nickname: NicknameDTO) async throws -> Int
    func deleteMember() async throws -> Int
}
