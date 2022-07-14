//
//  RoomDTO.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

struct CreateRoomDTO: Encodable {
    var room: RoomDTO
    var member: MemberDTO
}

struct RoomDTO: Encodable {
    let title: String
    let capacity: Int
    let startDate: String
    let endDate: String
}

struct MemberDTO: Encodable {
    var colorIdx: Int
}
