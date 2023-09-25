//
//  ChooseCharacterError.swift
//  Manito
//
//  Created by 이성호 on 2023/09/25.
//

import Foundation

enum ChooseCharacterError: LocalizedError {
    case roomAlreadyParticipating
    case someError
}
// FIXME: TextLiteral 처리는 듀나 작업 이후에 진행하겠습니다!
extension ChooseCharacterError {
    var errorDescription: String? {
        switch self {
        case .roomAlreadyParticipating: return "이미 참여중인 방입니다."
        case .someError: return "네트워크 오류입니다."
        }
    }
}
