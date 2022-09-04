//
//  Letter.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/12.
//

import Foundation

struct Letter: Codable {
    var count: Int?
    var manittee: Manitte?
    var messages: [Message]
}

struct Manitte: Codable {
    var id: String?
    var nickname: String?
}

struct Message: Codable {
    var id: Int?
    var content: String?
    var imageUrl: String?
}
