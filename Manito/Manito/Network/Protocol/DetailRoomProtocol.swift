//
//  DetailRoomProtocol.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/29.
//

import Foundation

protocol DetailRoomProtocol {
    func fetchStartingRoomInfo(roomId: String) async throws -> Room?
    func fetchDoneRoomInfo(roomId: String) async throws -> Room?
    func fetchWithFriend(roomId: String) async throws -> FriendList?
    func fetchMemory(roomId: String) async throws -> Memory?
    func deleteRoomByMember(roomId: String) async throws -> Int
    func deleteRoomByOwner(roomId: String) async throws -> Int
}
