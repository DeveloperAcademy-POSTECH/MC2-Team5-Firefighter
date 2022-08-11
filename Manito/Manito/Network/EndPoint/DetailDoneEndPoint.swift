//
//  DetailDoneEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailDoneEndPoint: EndPointable {
    case getWithFriend(roomId: String)
    case getHistoryWithManitto(roomId: String, subject: String)
    case getHistoryWithManitte(roomId: String, subject: String)
    case getDoneRoomInfo(roomId: String, subject: String)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getWithFriend:
            return .get
        case .getHistoryWithManitto:
            return .get
        case .getHistoryWithManitte:
            return .get
        case .getDoneRoomInfo:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .getWithFriend:
            return nil
        case .getHistoryWithManitto:
            return nil
        case .getHistoryWithManitte:
            return nil
        case .getDoneRoomInfo:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .getWithFriend(let roomId):
            return "\(baseURL)/api/rooms/\(roomId))/participants"
        case .getHistoryWithManitto(let roomId, let subject):
            return "\(baseURL)/api/rooms/\(roomId)/memories?subject=\(subject)"
        case .getHistoryWithManitte(let roomId, let subject):
            return "\(baseURL)/api/rooms/\(roomId)/memories?subject=\(subject)"
        case .getDoneRoomInfo(let roomId, let subject):
            return "\(baseURL)/api/rooms/\(roomId)?state=\(subject)"
        }
    }
}
