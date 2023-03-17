//
//  MainEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/10.
//

import Foundation

enum MainEndPoint: URLRepresentable {
    case fetchCommonMission
    case fetchManittoList

    var path: String {
        switch self {
        case .fetchCommonMission:
            return "/missions/common"
        case .fetchManittoList:
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
        case .fetchManittoList:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .fetchCommonMission:
            return nil
        case .fetchManittoList:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .fetchCommonMission:
            return self[.fetchCommonMission]
        case .fetchManittoList:
            return self[.fetchManittoList]
        }
    }
    
    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(UserDefaultStorage.accessToken)"
        
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseURL()),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
