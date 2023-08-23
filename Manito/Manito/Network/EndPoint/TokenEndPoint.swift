//
//  TokenEndPoint.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/14.
//

import Foundation

import MTNetwork

enum TokenEndPoint {
    case patchRefreshToken(body: Token)
}

extension TokenEndPoint: Requestable {
    var baseURL: URL {
        return APIEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .patchRefreshToken:
            return "/v1/auth/reissue"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .patchRefreshToken:
            return .patch
        }
    }

    var task: HTTPTask {
        switch self {
        case .patchRefreshToken(let body):
            let body = ["accessToken": body.accessToken,
                        "refreshToken": body.refreshToken]
            return .requestJSONEncodable(body)
        }
    }

    var headers: HTTPHeaders {
        let headers: [HTTPHeader] = [
            HTTPHeader.contentType("application/json"),
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
