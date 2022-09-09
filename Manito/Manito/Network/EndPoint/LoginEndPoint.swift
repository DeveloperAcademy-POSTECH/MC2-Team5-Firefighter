//
//  LoginEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

enum LoginEndPoint: EndPointable {
    case dispatchAppleLogin(body: LoginDTO)
    case putRefreshToken(body: RefreshToken)
    
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .dispatchAppleLogin:
            return .post
        case .putRefreshToken:
            return .put
        }
    }

    var requestBody: Data? {
        switch self {
        case .dispatchAppleLogin(let body):
            return body.encode()
        case .putRefreshToken(let body):
            return body.encode()
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .dispatchAppleLogin:
            return "\(baseURL)/login"
        case .putRefreshToken:
            return "\(baseURL)/auth/reissue"
        }
    }

    func createRequest(environment: APIEnvironment) -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(APIEnvironment.development.token)"
        return NetworkRequest(url: getURL(baseURL: environment.baseUrl),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }

}
