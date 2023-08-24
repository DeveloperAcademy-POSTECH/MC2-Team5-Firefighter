//
//  MessageListItemDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct MessageListItemDTO: Decodable {
    let id: Int?
    let content: String?
    let imageUrl: String?
    let createdDate: String?
    let missionInfo: Mission?
}
