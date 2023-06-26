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
    
    func patchEditMission(roomId: String, body: MissionDTO) async throws -> MissionDTO? {
        let request = MissionEditEndPoint
            .patchEditMission(roomId: roomId, body: body)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func fetchResetMission(roomId: String) async throws -> MissionDTO? {
        let request = MissionEditEndPoint
            .getResetMission(roomId: roomId)
            .createRequest()
        return try await apiService.request(request)
    }
}
