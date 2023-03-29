//
//  LetterAPI.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/08/31.
//

import Foundation

struct LetterAPI: LetterProtocol {
    private let apiService: Requestable

    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func fetchSentLetter(roomId: String) async throws -> Letter? {
        let request = LetterEndPoint
            .fetchSentLetter(roomId: roomId)
            .createRequest()
        return try await self.apiService.request(request)
    }
    
    func fetchReceivedLetter(roomId: String) async throws -> Letter? {
        let request = LetterEndPoint
            .fetchReceivedLetter(roomId: roomId)
            .createRequest()
        return try await self.apiService.request(request)
    }
    
    @discardableResult
    func dispatchLetter(roomId: String, image: Data? = nil, letter: LetterDTO, missionId: String) async throws -> Int {
        let request = LetterEndPoint
            .dispatchLetter(roomId: roomId, image: image, letter: letter, missionId: missionId)
            .createRequest()
        return try await self.apiService.request(request)
    }
}
