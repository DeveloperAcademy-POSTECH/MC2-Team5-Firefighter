//
//  DetailIngEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailIngEndPoint: EndPointable {
    case requestWithFriend(roomId: String)
    case requestStartingRoomInfo(roomId: String)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .requestWithFriend:
            return .get
        case .requestStartingRoomInfo:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .requestWithFriend:
            return nil
        case .requestStartingRoomInfo:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .requestWithFriend(let roomId):
            return "URLLiteral.DetailIng[.requestWithFriend(roomId: roomId)]"
        case .requestStartingRoomInfo(let roomId):
            return "URLLiteral.DetailIng[.requestStartingRoomInfo(roomId: roomId)]"
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
