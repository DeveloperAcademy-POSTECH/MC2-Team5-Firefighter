//
//  DetailIngEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailIngEndPoint: URLRepresentable {
    case fetchWithFriend(roomId: String)
    case fetchStartingRoomInfo(roomId: String)

    var path: String {
        switch self {
        case .fetchWithFriend(let roomId):
            return "/rooms/\(roomId)/participants"
        case .fetchStartingRoomInfo(let roomId):
            return "/rooms/\(roomId)"
        }
    }
}

extension DetailIngEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .fetchWithFriend:
            return .get
        case .fetchStartingRoomInfo:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .fetchWithFriend:
            return nil
        case .fetchStartingRoomInfo:
            return nil
        }
    }

    var url: String {
        switch self {
        case .fetchWithFriend(let roomId):
            return self[.fetchWithFriend(roomId: roomId)]
        case .fetchStartingRoomInfo(let roomId):
            return self[.fetchStartingRoomInfo(roomId: roomId)]
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
