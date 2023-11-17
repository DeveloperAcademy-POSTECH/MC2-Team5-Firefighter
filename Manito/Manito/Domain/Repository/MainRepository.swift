//
//  MainRepository.swift
//  Manito
//
//  Created by 이성호 on 10/31/23.
//

import Foundation

protocol MainRepository {
    func fetchCommonMission() async throws -> DailyMissionDTO
    func fetchManittoList() async throws -> RoomListDTO
}
