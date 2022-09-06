//
//  SettingProtocol.swift
//  Manito
//
//  Created by 이성호 on 2022/09/07.
//

import Foundation

protocol SettingProtocol {
    func putNickname(body: String) async throws -> String?
}
