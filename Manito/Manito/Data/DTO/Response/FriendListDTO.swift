//
//  FriendListDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct FriendListDTO: Decodable {
    let count: Int?
    let members: [MemberInfoDTO]?
}

struct MemberInfoDTO: Decodable {
    let nickname: String?
    let colorIndex: Int?

    enum CodingKeys: String, CodingKey {
        case nickname
        case colorIndex = "colorIdx"
    }
}
