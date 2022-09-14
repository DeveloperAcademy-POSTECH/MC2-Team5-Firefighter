//
//  TokenEndPoint.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/14.
//

import Foundation

enum TokenEndPoint: EndPointable {
    case patchRefreshToken(body: Token)
    
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .patchRefreshToken:
            return .patch
        }
    }

    var requestBody: Data? {
        switch self {
        case .patchRefreshToken(let body):
            let body = ["accessToken": body.accessToken,
                        "refreshToken": body.refreshToken]
            return body.encode()
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .patchRefreshToken:
            return "\(baseURL)/auth/reissue"
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
