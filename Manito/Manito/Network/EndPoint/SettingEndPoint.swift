//
//  SettingEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum SettingEndPoint: URLRepresentable {
    case editUserInfo(nickNameDto: NicknameDTO)

    var path: String {
        switch self {
        case .editUserInfo:
            return "/members/nickname"
        }
    }
}

extension SettingEndPoint: EndPointable {
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
        case .editUserInfo(let nicknameDTO):
            return self[.editUserInfo(nickNameDto: nicknameDTO)]
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
