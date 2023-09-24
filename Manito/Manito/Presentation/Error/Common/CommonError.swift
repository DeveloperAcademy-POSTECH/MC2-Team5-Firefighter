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
        // FIXME: - Common Error "애니또에 문제가 발생하였습니다."로 수정
        case .invalidAccess: return TextLiteral.errorAlertTitle
        }
    }
}
