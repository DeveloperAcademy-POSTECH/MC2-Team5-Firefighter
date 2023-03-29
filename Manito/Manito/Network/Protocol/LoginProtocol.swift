//
//  LoginProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

protocol LoginProtocol {
    func dispatchLogin(identityToken: String, fcmToken: String) async throws -> Login?
}
