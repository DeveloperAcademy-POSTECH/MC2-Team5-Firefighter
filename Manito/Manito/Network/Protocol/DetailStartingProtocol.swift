//
//  DetailIngProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

protocol DetailStartingProtocol {
    func requestStartingRoomInfo(roomId: String) async throws -> Room?
    func requestWithFriends(roomId: String) async throws -> FriendList?
}
