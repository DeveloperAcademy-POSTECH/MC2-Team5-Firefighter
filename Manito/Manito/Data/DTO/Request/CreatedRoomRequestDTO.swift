//
//  CreatedRoomRequestDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct CreatedRoomRequestDTO: Encodable {
    let room: CreatedRoomInfoRequestDTO
    let member: MemberInfoRequestDTO
}

struct CreatedRoomInfoRequestDTO: Encodable {
    let title: String
    let capacity: Int
    let startDate: String
    let endDate: String
}

struct MemberInfoRequestDTO: Encodable {
    let colorIndex: Int
}
