//
//  RoomParticipationProtocol.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/31.
//

import Foundation

protocol RoomParticipationProtocol {
    func dispatchCreateRoom(roomInfo: CreateRoomDTO) async throws -> Int?
    func dispatchVerification(code: String) async throws -> VerificationCode?
    func dispatchJoinRoom(roodId: String, colorIndex: Int) async throws -> Int
}
