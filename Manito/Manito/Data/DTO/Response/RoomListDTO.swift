//
//  RoomListDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct RoomListDTO: Decodable {
    let participatingRooms: [RoomListItemDTO]?
}

struct RoomListItemDTO: Decodable {
    let id: Int?
    let title: String?
    let state: String?
    let participatingCount: Int?
    let capacity: Int?
    let startDate: String?
    let endDate: String?
}
