//
//  MessageCountInfo.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/09/02.
//

import Foundation

///
/// 쪽지함 뱃지로 사용되는 Entity
///
struct MessageCountInfo {
    /// 쪽지 수 (옵션)
    let count: Int?
}

extension MessageCountInfo: Equatable {
    static let testMessageInfo = MessageCountInfo(count: 3)
}
