//
//  LoginEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

enum LoginEndPoint: URLRepresentable {
    case dispatchAppleLogin(body: LoginDTO)

    var path: String {
        switch self {
        case .dispatchAppleLogin:
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
        case .dispatchAppleLogin:
            return .post
        }
    }

    var requestBody: Data? {
        switch self {
        case .dispatchAppleLogin(let body):
            return body.encode()
        }
    }

    var url: String {
        switch self {
        case .dispatchAppleLogin(let loginDTO):
            return self[.dispatchAppleLogin(body: loginDTO), .v2]
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
