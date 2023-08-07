//
//  SettingEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum SettingEndPoint: URLRepresentable {
    case editUserInfo(nickNameDto: NicknameDTO)
    case deleteMember

    var path: String {
        switch self {
        case .editUserInfo:
            return "/members/nickname"
        case .deleteMember:
            return "/members"
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
        case .deleteMember:
            return .delete
        }
    }

    var requestBody: Data? {
        switch self {
        case .editUserInfo(let setting):
            let body = setting
            return body.encode()
        case .deleteMember:
            return nil
        }
    }

    var url: String {
        switch self {
        case .editUserInfo(let nicknameDTO):
            return self[.editUserInfo(nickNameDto: nicknameDTO)]
        case .deleteMember:
            return self[.deleteMember]
        }
    }
    
    func createRequest() -> NetworkRequest {
        switch self {
        case .editUserInfo(_):
            var headers: [String: String] = [:]
            headers["Content-Type"] = "application/json"
            headers["authorization"] = "Bearer \(UserDefaultStorage.accessToken)"
            
            return NetworkRequest(url: self.url,
                                  headers: headers,
                                  reqBody: self.requestBody,
                                  reqTimeout: self.requestTimeOut,
                                  httpMethod: self.httpMethod
            )
        case .deleteMember:
            return NetworkRequest(url: self.url,
                                  reqBody: self.requestBody,
                                  reqTimeout: self.requestTimeOut,
                                  httpMethod: self.httpMethod)
        }
    }
}
