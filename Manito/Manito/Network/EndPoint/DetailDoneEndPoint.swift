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
        }
    }
    
    func createRequest(environment: APIEnvironment) -> NetworkRequest {
        return NetworkRequest(url: getURL(baseURL: environment.baseUrl),
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
