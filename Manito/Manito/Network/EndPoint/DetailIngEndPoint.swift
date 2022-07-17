//
//  DetailIngEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailIngEndPoint: EndPointable {
    case getWithFriend(roomId: String)
    case getStartingRoomInfo(roomId: String, state: String)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getWithFriend:
            return .get
        case .getStartingRoomInfo:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .getWithFriend:
            return nil
        case .getStartingRoomInfo:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .getWithFriend(let roomId):
            return "\(baseURL)/api/rooms/\(roomId))/participants"
        case .getStartingRoomInfo(let roomId, let state):
            return "\(baseURL)/api/rooms/\(roomId)?state=\(state)"
        }
    }
}
