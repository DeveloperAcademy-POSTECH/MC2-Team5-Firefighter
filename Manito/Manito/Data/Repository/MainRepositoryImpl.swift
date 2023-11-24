//
//  MainRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

final class MainRepositoryImpl: MainRepository {

    private var provider = Provider<MainEndPoint>()

    func fetchCommonMission() async throws -> DailyMissionDTO {
        let response = try await self.provider
            .request(.fetchCommonMission)
        return try response.decode()
    }

    func fetchManittoList() async throws -> RoomListDTO {
        let response = try await self.provider
            .request(.fetchManittoList)
        return try response.decode()
    }
}
