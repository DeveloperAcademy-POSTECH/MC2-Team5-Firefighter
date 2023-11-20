//
//  DetailEditUsecaseError.swift
//  Manito
//
//  Created by Mingwan Choi on 11/20/23.
//

import Foundation

enum DetailEditUsecaseError: LocalizedError {
    case failedToChangeRoomInfo
}

extension DetailEditUsecaseError {
    var errorDescription: String? {
        switch self {
        case .failedToChangeRoomInfo: return TextLiteral.DetailEdit.Error.message.localized()
        }
    }
}
