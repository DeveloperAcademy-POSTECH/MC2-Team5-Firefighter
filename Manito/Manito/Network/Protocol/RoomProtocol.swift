//
//  RoomProtocol.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/31.
//

import Foundation

protocol RoomProtocol {
    func postCreateRoom(body: CreateRoomDTO) async throws -> Int?
    func dispatchVerification(body: String) async throws -> VerificationCode?
    func dispatchJoinRoom(roodId: String, dto: MemberDTO) async throws -> String?
}
