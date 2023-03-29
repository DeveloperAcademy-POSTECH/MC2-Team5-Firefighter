//
//  DetailWaitProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/08/27.
//

import Foundation

protocol DetailWaitProtocol {
    func fetchWithFriend(roomId: String) async throws -> FriendList?
    func fetchWaitingRoomInfo(roomId: String) async throws -> Room?
    func patchStartManitto(roomId: String) async throws -> Manittee?
    func putRoomInfo(roomId: String, roomInfo: RoomDTO) async throws -> Int
    func deleteRoom(roomId: String) async throws -> Int
    func deleteLeaveRoom(roomId: String) async throws -> Int
}
