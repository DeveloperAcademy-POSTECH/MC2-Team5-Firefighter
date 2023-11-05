//
//  ParticipateRoomError.swift
//  Manito
//
//  Created by 이성호 on 11/5/23.
//

import Foundation

enum ParticipateRoomError: LocalizedError {
    case invailedCode
    case clientError
}

extension ParticipateRoomError {
    var errorDescription: String? {
        switch self {
        case .invailedCode: return TextLiteral.ParticipateRoom.Error.message.localized()
        case .clientError: return TextLiteral.Common.Error.networkServer.localized()
        }
    }
}
