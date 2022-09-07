//
//  DetailEndProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

protocol DetailDoneProtocol {
    func requestMemory(roomId: String) async throws -> Memory?
    func requestDoneRoomInfo(roomId: String) async throws -> Room?
    func requestWithFriends(roomId: String) async throws -> FriendList?
}
