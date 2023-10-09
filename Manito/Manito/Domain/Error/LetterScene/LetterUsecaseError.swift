//
//  LetterUsecaseError.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/10.
//

import Foundation

enum LetterUsecaseError: LocalizedError {
    case failedToFetchLetter
}

extension LetterUsecaseError {
    var errorDescription: String? {
        switch self {
        case .failedToFetchLetter: return TextLiteral.Letter.Error.fetchMessage.localized()
        }
    }
}
