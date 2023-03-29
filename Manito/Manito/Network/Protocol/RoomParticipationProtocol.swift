//
//  RoomParticipationProtocol.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/31.
//

import Foundation

protocol RoomParticipationProtocol {
    func dispatchCreateRoom(body: CreateRoomDTO) async throws -> Int?
    func dispatchVerification(body: String) async throws -> VerificationCode?
    func dispatchJoinRoom(roodId: String, dto: MemberDTO) async throws -> Int
}
