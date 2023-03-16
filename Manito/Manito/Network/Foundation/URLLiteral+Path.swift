//
//  URLLiteral+Path.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/16.
//

import Foundation

extension URLLiteral {

    // MARK: - main path

    enum Main: String, RawRepresentable {
        case fetchCommonMission = "/missions/common/"
        case fetchManittoList = "/rooms/"
    }

    // MARK: - detailWait path

    enum DetailWait: URLRepresentable {
        case fetchWithFriend(roomId: String)
        case fetchWaitingRoomInfo(roomId: String)
        case patchStartManitto(roomId: String)
        case putRoomInfo(roomId: String)
        case deleteRoom(roomId: String)
        case deleteLeaveRoom(roomId: String)

        var rawValue: String {
            switch self {
            case .fetchWithFriend(roomId: let roomId):
                return "/rooms/\(roomId)/participants"
            case .fetchWaitingRoomInfo(roomId: let roomId):
                return "/rooms/\(roomId)"
            case .patchStartManitto(roomId: let roomId):
                return "/rooms/\(roomId)/state"
            case .putRoomInfo(roomId: let roomId):
                return "/rooms/\(roomId)"
            case .deleteRoom(roomId: let roomId):
                return "/rooms/\(roomId)"
            case .deleteLeaveRoom(roomId: let roomId):
                return "/rooms/\(roomId)/participants"
            }
        }
    }
}
