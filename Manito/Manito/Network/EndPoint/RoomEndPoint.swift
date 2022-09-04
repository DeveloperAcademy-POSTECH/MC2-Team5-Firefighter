//
//  RoomEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum RoomEndPoint: EndPointable {
    case createRoom(roomInfo: CreateRoomDTO)
    case verifyCode(code: String)
    case joinRoom(roomId: String, colorIndex: Int)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .createRoom:
            return .post
        case .verifyCode:
            return .get
        case .joinRoom:
            return .post
        }
    }

    var requestBody: Data? {
        switch self {
        case .createRoom(let roomInfo):
            let body = roomInfo
            return body.encode()
        case .verifyCode(let code):
            let body = ["invitationCode": code]
            return body.encode()
        case .joinRoom(_, let colorIndex):
            let body = ["colorIdx": colorIndex.description]
            return body.encode()
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .createRoom(_):
            return "\(baseURL)/rooms"
        case .verifyCode:
            return "\(baseURL)/invitations/verification"
        case .joinRoom(let roomId, _):
            return "\(baseURL)/rooms/\(roomId)/participaticipants"
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
