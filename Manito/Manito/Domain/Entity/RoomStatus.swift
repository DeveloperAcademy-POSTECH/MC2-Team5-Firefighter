//
//  RoomStatus.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/02.
//

import UIKit

///
/// 방 상태에 대한 정보들을 반환하는 Enum 데이터 입니다.
///

enum RoomStatus: String {
    /// 대기 중
    case PRE
    /// 진행 중
    case PROCESSING
    /// 진행 완료
    case POST
}

extension RoomStatus {
    /// 방 상태 뱃지에 들어가는 텍스트
    var badgeTitle: String {
        switch self {
        case .PRE: return TextLiteral.waiting
        case .PROCESSING: return TextLiteral.doing
        case .POST: return TextLiteral.done
        }
    }
    /// 방 상태 뱃지에 들어가는 배경 색상
    var badgeColor: UIColor {
        switch self {
        case .PRE: return .badgeBeige
        case .PROCESSING: return .mainRed
        case .POST: return .grey002
        }
    }
    /// 방 상태 뱃지에 들어가는 텍스트 색상
    var titleColor: UIColor {
        switch self {
        case .PRE: return .darkGrey001
        default: return .white
        }
    }
}
