//
//  RoomEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum RoomEndPoint {
    case createRoom
    case verifyCode
    case joinRoom(roomId: String)
}
