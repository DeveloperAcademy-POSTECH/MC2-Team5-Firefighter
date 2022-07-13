//
//  RoomDTO.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

struct RoomDTO: Encodable {
    let title: String
    let capacity: Int
    let startDate: String
    let endDate: String
}

struct CreateRoomDTO: Encodable {
    var room: RoomDTO
    var member: Member
}

struct Member: Encodable {
    var colorIndex: Int
}
