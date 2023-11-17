//
//  SettingError.swift
//  Manito
//
//  Created by 이성호 on 11/8/23.
//

import Foundation

enum SettingError: LocalizedError {
    case clientError
}

extension SettingError {
    var errorDescription: String? {
        switch self {
        case .clientError: return TextLiteral.Common.Error.networkServer.localized()
        }
    }
}
