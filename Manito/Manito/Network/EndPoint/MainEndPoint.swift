//
//  MainEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/10.
//

import Foundation

enum MainEndPoint: EndPointable {
    case getCommonMission
    case getManittoList

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getCommonMission:
            return .get
        case.getManittoList:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .getCommonMission:
            return nil
        case .getManittoList:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .getCommonMission:
            return "\(baseURL)/missions/common/"
        case .getManittoList:
            return "\(baseURL)/rooms/"
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
