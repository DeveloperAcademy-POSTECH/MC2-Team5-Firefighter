//
//  DetailWaitProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/08/27.
//

import Foundation

protocol DetailWaitProtocol {
    func getWithFriend(roomId: String) async throws -> FriendList?
    func getWaitingRoomInfo(roomId: String) async throws -> Room?
    func startManitto(roomId: String) async throws -> String?
    func editRoomInfo(roomId: String, roomInfo: RoomDTO) async throws -> String?
    func deleteRoom(roomId: String) async throws -> String?
    func deleteLeaveRoom(roomId: String) async throws -> String?
}
