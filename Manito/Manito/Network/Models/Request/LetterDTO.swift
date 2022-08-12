//
//  LetterDTO.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/14.
//

import Foundation

struct SendMessageDTO: Encodable {
    var receiver: UserIdDTO
    var message: MessageDTO
}

struct UserIdDTO: Encodable {
    var id: String
}

struct MessageDTO: Encodable {
    var content: String
    var image: String
}
