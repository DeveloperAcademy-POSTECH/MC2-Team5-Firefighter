//
//  MissionEditAPI.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/06/25.
//

import Foundation

struct MissionEditAPI: MissionEditProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func patchEditMission(roomId: String, body: MissionDTO) async throws -> String? {
        let request = MissionEditEndPoint
            .patchEditMission(roomId: roomId, body: body)
            .createRequest()
        return try await apiService.request(request)
    }
}
