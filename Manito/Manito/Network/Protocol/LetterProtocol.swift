//
//  LetterProtocol.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/08/31.
//

import Foundation

protocol LetterProtocol {
    func fetchSentLetter(roomId: String) async throws -> Letter?
    func fetchReceivedLetter(roomId: String) async throws -> Letter?
    func dispatchLetter(roomId: String, image: Data?, letter: LetterDTO, missionId: String) async throws -> Int
}
