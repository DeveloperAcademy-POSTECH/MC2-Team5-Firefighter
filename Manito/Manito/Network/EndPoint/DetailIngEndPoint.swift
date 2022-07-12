//
//  DetailIngEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailIngEndPoint {
    case getWithFriend(roomId: String)
    case getStartingRoomInfo(roomId: String, state: String)
}
