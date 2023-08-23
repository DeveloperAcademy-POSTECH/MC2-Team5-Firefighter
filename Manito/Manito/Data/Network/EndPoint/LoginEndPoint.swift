//
//  LoginEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/09/09.
//

import Foundation

import MTNetwork

enum LoginEndPoint {
    case dispatchAppleLogin(loginDTO: LoginDTO)
}

extension LoginEndPoint: Requestable {
    var baseURL: URL {
        return APIEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .dispatchAppleLogin:
            return "/v2/login"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .dispatchAppleLogin:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .dispatchAppleLogin(let body):
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
