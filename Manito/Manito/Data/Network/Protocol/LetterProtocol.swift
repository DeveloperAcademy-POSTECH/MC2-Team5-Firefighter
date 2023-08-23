//
//  LetterProtocol.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/08/31.
//

import Foundation

protocol LetterProtocol {
    func fetchSendLetter(roomId: String) async throws -> Letter?
    func fetchReceiveLetter(roomId: String) async throws -> Letter?
    func dispatchLetter(roomId: String, image: Data?, letter: LetterDTO, missionId: String) async throws -> Int
}
