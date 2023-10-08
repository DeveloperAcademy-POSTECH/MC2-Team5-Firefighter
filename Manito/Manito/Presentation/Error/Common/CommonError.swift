//
//  CommonError.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/24.
//

import Foundation

enum CommonError: LocalizedError {
    case invalidAccess
}

extension CommonError {
    var errorDescription: String? {
        switch self {
        case .invalidAccess: return TextLiteral.Common.Error.networkServer.localized()
        }
    }
}
