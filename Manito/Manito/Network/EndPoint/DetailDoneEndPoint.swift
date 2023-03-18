//
//  DetailDoneEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailDoneEndPoint: URLRepresentable {
    case requestWithFriend(roomId: String)
    case requestMemory(roomId: String)
    case requestDoneRoomInfo(roomId: String)
    case requestExitRoom(roomId: String)
    case requestDeleteRoom(roomId: String)

    var path: String {
        switch self {
        case .requestWithFriend(let roomId):
            return "/rooms/\(roomId)/participants"
        case .requestMemory(let roomId):
            return "/rooms/\(roomId)/memories"
        case .requestDoneRoomInfo(let roomId):
            return "/rooms/\(roomId)"
        case .requestExitRoom(let roomId):
            return "/rooms/\(roomId)/participants"
        case .requestDeleteRoom(let roomId):
            return "/rooms/\(roomId)"
        }
    }
}

extension DetailDoneEndPoint: EndPointable {
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
            return self[.requestWithFriend(roomId: roomId)]
        case .requestMemory(let roomId):
            return self[.requestMemory(roomId: roomId)]
        case .requestDoneRoomInfo(let roomId):
            return self[.requestDoneRoomInfo(roomId: roomId)]
        case .requestExitRoom(let roomId):
            return self[.requestExitRoom(roomId: roomId)]
        case .requestDeleteRoom(let roomId):
            return self[.requestDeleteRoom(roomId: roomId)]
        }
    }
    
    func createRequest() -> NetworkRequest {
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseURL()),
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
