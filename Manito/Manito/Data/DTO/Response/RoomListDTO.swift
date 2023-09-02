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

extension RoomListItemDTO {
    func toRoomListItem() -> RoomListItem {
        return RoomListItem(id: self.id ?? 0,
                            title: self.title ?? "",
                            state: self.state ?? "PRE",
                            participatingCount: self.participatingCount,
                            capacity: self.capacity ?? 0,
                            startDate: self.startDate ?? "",
                            endDate: self.endDate ?? ""
        )
    }
}
