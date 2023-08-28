//
//  MemoryDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct MemoryDTO: Decodable {
    let memoriesWithManitto: MemoryItemDTO?
    let memoriesWithManittee: MemoryItemDTO?
}

struct MemoryItemDTO: Decodable {
    let member: MemberInfoDTO?
    let messages: [MessageListItemDTO]?
}
