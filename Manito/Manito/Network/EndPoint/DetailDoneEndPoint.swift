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
            return URLLiteral.DetailDone[.requestWithFriend(roomId: roomId)]
        case .requestMemory(let roomId):
            return URLLiteral.DetailDone[.requestMemory(roomId: roomId)]
        case .requestDoneRoomInfo(let roomId):
            return URLLiteral.DetailDone[.requestDoneRoomInfo(roomId: roomId)]
        case .requestExitRoom(let roomId):
            return URLLiteral.DetailDone[.requestExitRoom(roomId: roomId)]
        case .requestDeleteRoom(let roomId):
            return URLLiteral.DetailDone[.requestDeleteRoom(roomId: roomId)]
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
