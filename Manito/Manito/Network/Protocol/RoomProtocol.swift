//
//  RoomProtocol.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/31.
//

import Foundation

protocol RoomProtocol {
    func postCreateRoom(body: CreateRoomDTO) async throws -> String?
    func getVerification(body: String) async throws -> VerificationCode?
    func postJoinRoom(roodId: String, body: Int) async throws -> String?
}
