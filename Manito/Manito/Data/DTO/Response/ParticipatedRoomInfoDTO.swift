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
