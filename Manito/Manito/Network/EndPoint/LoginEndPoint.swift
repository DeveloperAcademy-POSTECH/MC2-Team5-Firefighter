//
//  LoginEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

enum LoginEndPoint: EndPointable {
    case dispatchAppleLogin(body: LoginDTO)
    
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

    func getURL(baseURL: String) -> String {
        switch self {
        case .dispatchAppleLogin:
            return "\(baseURL)/login"
        }
    }

    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseUrl),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }

}
