//
//  MainEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/10.
//

import Foundation

import MTNetwork

enum MainEndPoint {
    case fetchCommonMission
    case fetchManittoList
}

extension MainEndPoint: Requestable {
    var baseURL: URL {
        return APIEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .fetchCommonMission:
            return "/v1/missions/common"
        case .fetchManittoList:
            return "/v1/rooms"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchCommonMission:
            return .get
        case .fetchManittoList:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .fetchCommonMission:
            return .requestPlain
        case .fetchManittoList:
            return .requestPlain
        }
    }

    var headers: HTTPHeaders {
        let headers: [HTTPHeader] = [
            HTTPHeader.contentType("application/json"),
            HTTPHeader.authorization(bearerToken: UserDefaultStorage.accessToken)
        ]
        return HTTPHeaders(headers)
    }
    
    var requestTimeout: Float {
        return 10
    }

    var sampleData: Data? {
        return nil
    }
}
