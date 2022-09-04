//
//  MainProtocal.swift
//  Manito
//
//  Created by COBY_PRO on 2022/09/01.
//

import Foundation

protocol MainProtocol {
    func fetchCommonMission() async throws -> String?
    func fetchManittoList() async throws -> ParticipatingRooms?
}
