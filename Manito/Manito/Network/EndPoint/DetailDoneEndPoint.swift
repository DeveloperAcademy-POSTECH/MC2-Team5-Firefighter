//
//  DetailDoneEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailDoneEndPoint: EndPointable {
    case requestWithFriend(roomId: String)
    case requestMemory(roomId: String)
    case requestDoneRoomInfo(roomId: String)
    case requestExitRoom(roomId: String)
    case requestDeleteRoom(roomId: String)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .requestWithFriend:
            return .get
        case .requestMemory:
            return .get
        case .requestDoneRoomInfo:
            return .get
        case .requestExitRoom:
            return .delete
        case .requestDeleteRoom:
            return .delete
        }
    }

    var requestBody: Data? {
        switch self {
        case .requestWithFriend:
            return nil
        case .requestMemory:
            return nil
        case .requestDoneRoomInfo:
            return nil
        case .requestExitRoom:
            return nil
        case .requestDeleteRoom:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .requestWithFriend(let roomId):
            return "\(baseURL)/rooms/\(roomId))/participants"
        case .requestMemory(let roomId):
            return "\(baseURL)/rooms/\(roomId)/memories"
        case .requestDoneRoomInfo(let roomId):
            return "\(baseURL)/rooms/\(roomId)"
        case .requestExitRoom(let roomId):
            return "\(baseURL)/rooms/\(roomId)/participants"
        case .requestDeleteRoom(let roomId):
            return "\(baseURL)/rooms/\(roomId)"
        }
    }
    
    func createRequest() -> NetworkRequest {
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseUrl),
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
