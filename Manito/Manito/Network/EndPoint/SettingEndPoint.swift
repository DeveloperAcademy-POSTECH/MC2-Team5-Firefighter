//
//  SettingEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum SettingEndPoint: EndPointable {
    case editUserInfo(nickNameDto: NicknameDTO)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .editUserInfo:
            return .put
        }
    }

    var requestBody: Data? {
        switch self {
        case .editUserInfo(let setting):
            let body = setting
            return body.encode()
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .editUserInfo(_):
            return "\(baseURL)/members/nickname"
        }
    }
    
    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(APIEnvironment.token)"
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseUrl),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
