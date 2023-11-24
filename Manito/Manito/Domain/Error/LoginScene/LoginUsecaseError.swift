//
//  LoginUsecaseError.swift
//  Manito
//
//  Created by COBY_PRO on 11/9/23.
//

import Foundation

enum LoginUsecaseError: LocalizedError {
    case failedToLogin
    case failedCredential
    case failedToken
    case failedTokenToString
}

extension LoginUsecaseError {
    var errorDescription: String? {
        switch self {
        case .failedToLogin:
            return TextLiteral.Common.Error.networkServer.localized()
        case .failedCredential:
            return TextLiteral.Sign.Error.credential.localized()
        case .failedToken:
            return TextLiteral.Sign.Error.token.localized()
        case .failedTokenToString:
            return TextLiteral.Sign.Error.tokenToString.localized()
        }
    }
}
