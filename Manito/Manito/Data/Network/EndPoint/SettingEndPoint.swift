//
//  SettingEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

import MTNetwork

enum SettingEndPoint {
    case putUserInfo(nickname: NicknameDTO)
}

extension SettingEndPoint: Requestable {
    var baseURL: URL {
        return APIEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .putUserInfo:
            return "/v1/members/nickname"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .putUserInfo:
            return .put
        }
    }

    var task: HTTPTask {
        switch self {
        case .putUserInfo(let nickname):
            return .requestJSONEncodable(nickname)
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
