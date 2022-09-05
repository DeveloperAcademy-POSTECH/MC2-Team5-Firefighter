//
//  MainEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/10.
//

import Foundation

enum MainEndPoint: EndPointable {
    case fetchCommonMission
    case fetchManittoList

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
            return "\(baseURL)/missions/common/"
        case .fetchManittoList:
            return "\(baseURL)/rooms/"
        }
    }
    
    func createRequest(environment: APIEnvironment) -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(APIEnvironment.development.token)"
        return NetworkRequest(url: getURL(baseURL: environment.baseUrl),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
