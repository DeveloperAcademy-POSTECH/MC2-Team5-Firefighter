//
//  LetterAPI.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/08/31.
//

import Foundation

struct LetterAPI: LetterProtocol {
    
    private let apiService: Requestable
    private let environment: APIEnvironment

    init(apiService: Requestable, environment: APIEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }
    
    func fetchSendLetter(roomId: String) async throws -> Letter? {
        let request = LetterEndPoint
            .fetchSendLetter(roomId: roomId)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
}

