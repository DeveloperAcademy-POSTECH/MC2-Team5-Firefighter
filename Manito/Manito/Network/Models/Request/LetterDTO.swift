//
//  LetterDTO.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/14.
//

import Foundation

struct LetterDTO: Encodable {
    var manitteeId: String?
    var messageContent: String?
    
    init(manitteeId: String?, messageContent: String? = nil) {
        self.manitteeId = manitteeId
        self.messageContent = messageContent
    }
}
