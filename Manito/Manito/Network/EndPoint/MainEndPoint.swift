//
//  MainEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/10.
//

import Foundation

enum MainEndPoint: URLRepresentable {
    case fetchCommonMission
    case fetchRooms

    var path: String {
        switch self {
        case .fetchCommonMission:
            return "/missions/common"
        case .fetchRooms:
            return "/rooms"
        }
    }
}

extension MainEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .fetchCommonMission:
            return .get
        case .fetchRooms:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .fetchCommonMission:
            return nil
        case .fetchRooms:
            return nil
        }
    }

    var url: String {
        switch self {
        case .fetchCommonMission:
            return self[.fetchCommonMission]
        case .fetchRooms:
            return self[.fetchRooms]
        }
    }
    
    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(UserDefaultStorage.accessToken)"
        
        return NetworkRequest(url: self.url,
                              headers: headers,
                              reqBody: self.requestBody,
                              reqTimeout: self.requestTimeOut,
                              httpMethod: self.httpMethod
        )
    }
}
