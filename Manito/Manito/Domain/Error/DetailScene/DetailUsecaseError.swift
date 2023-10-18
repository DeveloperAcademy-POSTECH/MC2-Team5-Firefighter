//
//  DetailUsecaseError.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Foundation

enum DetailUsecaseError: LocalizedError {
    case failedToFetchMemory
}

extension DetailUsecaseError {
    var errorDescription: String? {
        switch self {
        case .failedToFetchMemory: return TextLiteral.Common.Error.networkServer.localized()
        }
    }
}
