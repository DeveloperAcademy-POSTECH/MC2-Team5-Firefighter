//
//  DetailIngProtocol.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/04.
//

import Foundation

protocol DetailIngProtocol {
    func fetchStartingRoomInfo(roomId: String) async throws -> Room?
    func fetchWithFriends(roomId: String) async throws -> FriendList?
}
