//
//  DetailEndProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

protocol DetailDoneProtocol {
    func fetchMemory(roomId: String) async throws -> Memory?
    func fetchDoneRoomInfo(roomId: String) async throws -> Room?
    func fetchWithFriend(roomId: String) async throws -> FriendList?
    func deleteRoomByMember(roomId: String) async throws -> Int
    func deleteRoomByOwner(roomId: String) async throws -> Int
}
