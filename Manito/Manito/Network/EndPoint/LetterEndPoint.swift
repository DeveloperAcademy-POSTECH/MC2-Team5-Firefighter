//
//  LetterEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum LetterEndPoint: EndPointable {
    case dispatchLetter(roomId: String, dto: SendMessageDTO)
    case fetchSendLetter(roomId: String)
    case fetchReceiveLetter(roomId: String)
    case patchReadMessage(roomId: String, status: String)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .dispatchLetter:
            return .post
        case .fetchSendLetter:
            return .get
        case .fetchReceiveLetter:
            return .get
        case .patchReadMessage:
            return .patch
        }
    }

    var requestBody: Data? {
        switch self {
        case .dispatchLetter(_, let dto):
            let body = dto
            return body.encode()
        case .fetchSendLetter:
            return nil
        case .fetchReceiveLetter:
            return nil
        case .patchReadMessage(_, let status):
            let body = ["status": status]
            return body.encode()
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .dispatchLetter(let roomId, _):
            return "\(baseURL)/rooms/\(roomId)/messages"
        case .fetchSendLetter(let roomId):
            return "\(baseURL)/rooms/\(roomId)/messages-sent"
        case .fetchReceiveLetter(let roomId):
            return "\(baseURL)/rooms/\(roomId)/messages"
        case .patchReadMessage(let roomId, _):
            return "\(baseURL)/rooms/\(roomId)/messages/status"
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
                              httpMethod: httpMethod)
    }
}
