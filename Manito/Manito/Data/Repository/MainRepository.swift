//
//  MainRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol MainRepository {
    func fetchCommonMission() async throws -> DailyMission?
    func fetchManittoList() async throws -> ParticipatingRooms?
}

final class MainRepositoryImpl: MainRepository {

    private var provider = Provider<MainEndPoint>()

    func fetchCommonMission() async throws -> DailyMission? {
        let response = try await self.provider.request(.fetchCommonMission)
        return try response.decode()
    }

    func fetchManittoList() async throws -> ParticipatingRooms? {
        let response = try await self.provider.request(.fetchManittoList)
        return try response.decode()
    }
}
