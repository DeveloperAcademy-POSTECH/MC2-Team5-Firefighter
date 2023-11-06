//
//  NicknameError.swift
//  Manito
//
//  Created by 이성호 on 11/6/23.
//

import Foundation

enum NicknameError: LocalizedError {
    case clientError
}

extension NicknameError {
    var errorDescription: String? {
        switch self {
        case .clientError: return TextLiteral.Common.Error.networkServer.localized()
        }
    }
}
