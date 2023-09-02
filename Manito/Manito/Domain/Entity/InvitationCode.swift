//
//  InvitationCode.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation

struct InvitationCode: Decodable {
    let code: String
}

extension InvitationCode: Equatable {
    static let testInvitationCode = InvitationCode(code: "ABCDEF")
}
