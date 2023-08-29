//
//  LetterRequestDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct LetterRequestDTO: Encodable {
    let manitteeId: String
    let messageContent: String?

    init(manitteeId: String, messageContent: String? = nil) {
        self.manitteeId = manitteeId
        self.messageContent = messageContent
    }
}
