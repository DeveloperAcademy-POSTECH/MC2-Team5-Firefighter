//
//  DetailUsecaseError.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Foundation

enum DetailUsecaseError: LocalizedError {
    case failedToFetchMemory
    case failedToFetchManitto
    case failedToFetchFriend
}

extension DetailUsecaseError {
    var errorDescription: String? {
        switch self {
        case .failedToFetchMemory:
            return TextLiteral.Common.Error.networkServer.localized()
        case .failedToFetchManitto:
            return TextLiteral.DetailIng.Error.openManittoMessage.localized()
        case .failedToFetchFriend:
            return TextLiteral.DetailIng.Error.fetchFriendMessage.localized()
        }
    }
}
