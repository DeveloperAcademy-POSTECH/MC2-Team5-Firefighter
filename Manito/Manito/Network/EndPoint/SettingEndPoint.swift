//
//  SettingEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum SettingEndPoint: URLRepresentable {
    case putNickname(nicknameDTO: NicknameDTO)

    var path: String {
        switch self {
        case .putNickname:
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
        case .putNickname:
            return .put
        }
    }

    var requestBody: Data? {
        switch self {
        case .putNickname(let setting):
            let body = setting
            return body.encode()
        }
    }

    var url: String {
        switch self {
        case .putNickname(let nicknameDTO):
            return self[.putNickname(nicknameDTO: nicknameDTO)]
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
