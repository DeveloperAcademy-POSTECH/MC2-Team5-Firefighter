//
//  RoomEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum RoomEndPoint: EndPointable {
    case dispatchCreateRoom(roomInfo: CreateRoomDTO)
    case fetchVerifyCode(code: String)
    case dispatchJoinRoom(roomId: String, roomDto: RoomDTO)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .dispatchCreateRoom:
            return .post
        case .fetchVerifyCode:
            return .post
        case .dispatchJoinRoom:
            return .post
        }
    }

    var requestBody: Data? {
        switch self {
        case .dispatchCreateRoom(let roomInfo):
            let body = roomInfo
            return body.encode()
        case .fetchVerifyCode(let code):
            let body = ["invitationCode": code]
            return body.encode()
        case .dispatchJoinRoom(_, let roomDto):
            let body = roomDto
            return body.encode()
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .dispatchCreateRoom(_):
            return "\(baseURL)/rooms"
        case .fetchVerifyCode:
            return "\(baseURL)/invitations/verification"
        case .dispatchJoinRoom(let roomId, _):
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
