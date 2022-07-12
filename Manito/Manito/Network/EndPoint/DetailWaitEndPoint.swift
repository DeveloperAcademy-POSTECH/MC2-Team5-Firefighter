//
//  DetailWaitEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailWaitEndPoint {
    case getWithFriend(roomId: String)
    case getWaitingRoomInfo(roomId: String, state: String)
    case startManitto(roomId: String)
    case editRoomInfo(roomId: String)
    case deleteRoom(roomId: String)
}
