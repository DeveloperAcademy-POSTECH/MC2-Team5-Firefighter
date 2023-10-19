//
//  ChooseCharacterError.swift
//  Manito
//
//  Created by 이성호 on 2023/09/25.
//

import Foundation

enum ChooseCharacterError: LocalizedError {
    case roomAlreadyParticipating
    case clientError
}

extension ChooseCharacterError {
    var errorDescription: String? {
        switch self {
        case .roomAlreadyParticipating: return TextLiteral.ParticipateRoom.Error.alreadyJoinMessage.localized()
        case .clientError: return TextLiteral.Common.Error.networkServer.localized()
        }
    }
}
