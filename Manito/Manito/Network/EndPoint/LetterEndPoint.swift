//
//  LetterEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum LetterEndPoint {
    case sendLetter(roomId: String)
    case getSendLetter(roomId: String)
    case getReceiveLetter(roomId: String)
    case changeReadMessage(roomId: String)
}
