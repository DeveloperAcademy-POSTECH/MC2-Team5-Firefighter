//
//  MisstionEditProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/06/25.
//

import Foundation

protocol MissionEditProtocol {
    func patchEditMission(roomId: String, body: MissionDTO) async throws -> MissionDTO?
}
