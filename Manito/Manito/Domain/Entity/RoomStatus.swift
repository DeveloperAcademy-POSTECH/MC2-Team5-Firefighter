//
//  RoomStatus.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/02.
//

import Foundation

enum RoomStatus: String {
    case PRE
    case PROCESSING
    case POST
}

extension RoomStatus {
    var badgeTitle: String {
        switch self {
        case .PRE:
            return TextLiteral.waiting
        case .PROCESSING:
            return TextLiteral.doing
        case .POST:
            return TextLiteral.done
        }
    }
}
