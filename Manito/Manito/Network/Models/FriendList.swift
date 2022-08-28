//
//  FriendList.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/08/27.
//

import Foundation

struct FriendList: Decodable {
    let count: Int?
    let members: [Member]?
}

struct Member: Decodable {
    let nickname: String?
    let colorIdx: Int?
}
