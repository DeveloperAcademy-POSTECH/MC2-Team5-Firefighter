//
//  LoginEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

enum LoginEndPoint: URLRepresentable {
    case dispatchLogin(loginDTO: LoginDTO)

    var path: String {
        switch self {
        case .dispatchLogin:
            return "/login"
        }
    }
}

extension LoginEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .dispatchLogin:
            return .post
        }
    }

    var requestBody: Data? {
        switch self {
        case .dispatchLogin(let body):
            return body.encode()
        }
    }

    var url: String {
        switch self {
        case .dispatchLogin(let loginDTO):
            return self[.dispatchLogin(loginDTO: loginDTO), .v2]
        }
    }

    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"

        return NetworkRequest(url: self.url,
                              headers: headers,
                              reqBody: self.requestBody,
                              reqTimeout: self.requestTimeOut,
                              httpMethod: self.httpMethod
        )
    }
}
