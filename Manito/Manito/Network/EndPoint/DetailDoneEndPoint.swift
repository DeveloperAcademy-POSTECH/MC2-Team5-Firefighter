//
//  DetailDoneEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailDoneEndPoint {
    case getWithFriend(roomId: String)
    case getHistoryWithManitto(roomId: String, subject: String)
    case getHistoryWithManatte(roomId: String, subject: String)
    case getDoneRoomInfo(roomId: String)
}
