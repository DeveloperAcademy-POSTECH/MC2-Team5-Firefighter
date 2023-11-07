//
//  CreateRoomError.swift
//  Manito
//
//  Created by 이성호 on 10/30/23.
//

import Foundation

enum CreateRoomError: LocalizedError {
    case failedToCreateRoom
}

extension CreateRoomError {
    var errorDescription: String? {
        switch self {
        case .failedToCreateRoom: return TextLiteral.Common.Error.networkServer.localized()
        }
    }
}
