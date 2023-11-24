//
//  InvitationCode.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation

///
/// 초대 코드에 대한 Entity
///
struct InvitationCode {
    /// 초대 코드
    let code: String
}

extension InvitationCode: Equatable {
    static let testInvitationCode = InvitationCode(code: "ABCDEF")
}
