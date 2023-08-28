//
//  LetterDTO.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct LetterDTO: Decodable {
    let count: Int?
    let manittee: UserInfoDTO?
    let messages: [MessageListItemDTO]
}
