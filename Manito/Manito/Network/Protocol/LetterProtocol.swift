//
//  LetterProtocol.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/08/31.
//

import Foundation

protocol LetterProtocol {
    func fetchSendLetter(roomId: String) async throws -> Letter?
}
