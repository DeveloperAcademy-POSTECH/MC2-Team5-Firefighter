//
//  Memory.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

struct Memory: Decodable {
    let memoriesWithManitto, memoriesWithManittee: MemoriesWithManitte?
}

struct MemoriesWithManitte: Decodable {
    let member: User?
    let messages: [Message2]?
}

struct Message2: Decodable {
    let id: Int?
    let content, imageUrl: String?
}
