//
//  MessageCountInfo.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation

struct MessageCountInfo {
    let count: Int?
}

extension MessageCountInfo: Equatable {
    static let testMessageInfo = MessageCountInfo(count: 3)
}
