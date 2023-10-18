//
//  DetailUsecaseError.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Foundation

enum DetailUsecaseError: LocalizedError {
    case failedToFetchMemory
    case failedToFetchFriend
}

extension DetailUsecaseError {
    var errorDescription: String? {
        return TextLiteral.Common.Error.networkServer.localized()
    }
}
