//
//  DetailIngEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailIngEndPoint: URLRepresentable {
    case requestWithFriend(roomId: String)
    case requestStartingRoomInfo(roomId: String)
    case getResetMission(roomId: String)

    var path: String {
        switch self {
        case .requestWithFriend(let roomId):
            return "/rooms/\(roomId)/participants"
        case .requestStartingRoomInfo(let roomId):
            return "/rooms/\(roomId)"
        case .getResetMission(let roomId):
            return "/\(roomId)/individual-mission/restore"
        }
    }
}

extension DetailIngEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .requestWithFriend:
            return .get
        case .requestStartingRoomInfo:
            return .get
        case .getResetMission:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .requestWithFriend:
            return nil
        case .requestStartingRoomInfo:
            return nil
        case .getResetMission:
            return nil
        }
    }

    var url: String {
        switch self {
        case .requestWithFriend(let roomId):
            return self[.requestWithFriend(roomId: roomId)]
        case .requestStartingRoomInfo(let roomId):
            return self[.requestStartingRoomInfo(roomId: roomId)]
        case .getResetMission(let roomId):
            return self[.getResetMission(roomId: roomId)]
        }
    }
    
    func createRequest() -> NetworkRequest {
        return NetworkRequest(url: self.url,
                              reqBody: self.requestBody,
                              reqTimeout: self.requestTimeOut,
                              httpMethod: self.httpMethod
        )
    }
}
