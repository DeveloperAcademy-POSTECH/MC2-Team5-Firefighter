//
//  LetterRepository.swift
//  Manito
//
//  Created by 이성호 on 10/31/23.
//

import Foundation

protocol LetterRepository {
    func dispatchLetter(roomId: String, image: Data?, letter: LetterRequestDTO, missionId: String) async throws -> Int
    func fetchSendLetter(roomId: String) async throws -> LetterDTO
    func fetchReceiveLetter(roomId: String) async throws -> LetterDTO
}
