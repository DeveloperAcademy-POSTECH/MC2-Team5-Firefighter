//
//  ParticipatedRoomInfoDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct ParticipatedRoomInfoDTO: Decodable {
    let id: Int?
    let title: String?
    let capacity: Int?
    let participatingCount: Int?
    let startDate: String?
    let endDate: String?
}

extension ParticipatedRoomInfoDTO {
    func toRoomInfo() -> ParticipateRoomInfo {
        return ParticipateRoomInfo(id: self.id ?? 0,
                                   title: self.title ?? "",
                                   capacity: self.capacity ?? 0,
                                   participatingCount: self.participatingCount ?? 0,
                                   startDate: self.startDate ?? "",
                                   endDate: self.endDate ?? "")
    }
}
