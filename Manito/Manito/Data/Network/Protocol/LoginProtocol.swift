//
//  LoginProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

protocol LoginProtocol {
    func dispatchAppleLogin(dto: LoginDTO) async throws -> Login?
}
