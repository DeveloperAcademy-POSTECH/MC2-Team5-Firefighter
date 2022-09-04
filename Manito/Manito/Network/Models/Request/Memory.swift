//
//  Memory.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

struct Memory: Decodable {
    let memoriesWithManitto, memoriesWithManittee: MemoriesWithManitt?
}

struct MemoriesWithManitt: Decodable {
    let member: User?
    let messages: [Message]?
}

struct Message: Decodable {
    let id: Int?
    let content, imageUrl: String?
}
