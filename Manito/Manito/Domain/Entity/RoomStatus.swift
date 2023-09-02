//
//  RoomStatus.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/02.
//

import UIKit

enum RoomStatus: String {
    case PRE
    case PROCESSING
    case POST
}

extension RoomStatus {
    var badgeTitle: String {
        switch self {
        case .PRE: return TextLiteral.waiting
        case .PROCESSING: return TextLiteral.doing
        case .POST: return TextLiteral.done
        }
    }

    var badgeColor: UIColor {
        switch self {
        case .PRE: return .badgeBeige
        case .PROCESSING: return .mainRed
        case .POST: return .grey002
        }
    }

    var titleColor: UIColor {
        switch self {
        case .PRE: return .darkGrey001
        default: return .white
        }
    }
}
