//
//  RoomEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum RoomEndPoint: URLRepresentable {
    case dispatchCreateRoom(roomInfo: CreateRoomDTO)
    case fetchVerifyCode(code: String)
    case dispatchJoinRoom(roomId: String, roomDto: MemberDTO)

    var path: String {
        switch self {
        case .dispatchCreateRoom:
            return "/rooms"
        case .fetchVerifyCode:
            return "/invitations/verification"
        case .dispatchJoinRoom(let roomId, _):
            return "/rooms/\(roomId)/participants"
        }
    }
}

extension RoomEndPoint: EndPointable {
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
        case .dispatchCreateRoom(let roomInfo):
            return self[.dispatchCreateRoom(roomInfo: roomInfo)]
        case .fetchVerifyCode(let code):
            return self[.fetchVerifyCode(code: code)]
        case .dispatchJoinRoom(let roomId, let roomDTO):
            return self[.dispatchJoinRoom(roomId: roomId, roomDto: roomDTO)]
        }
    }
    
    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(UserDefaultStorage.accessToken)"
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseURL()),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
