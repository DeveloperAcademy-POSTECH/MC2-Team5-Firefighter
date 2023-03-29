//
//  RoomParticipationEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum RoomParticipationEndPoint: URLRepresentable {
    case dispatchCreateRoom(roomInfo: CreateRoomDTO)
    case dispatchVerifyCode(code: String)
    case dispatchJoinRoom(roomId: String, memberDTO: MemberDTO)

    var path: String {
        switch self {
        case .dispatchCreateRoom:
            return "/rooms"
        case .dispatchVerifyCode:
            return "/invitations/verification"
        case .dispatchJoinRoom(let roomId, _):
            return "/rooms/\(roomId)/participants"
        }
    }
}

extension RoomParticipationEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .dispatchCreateRoom:
            return .post
        case .dispatchVerifyCode:
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
        case .dispatchVerifyCode(let code):
            let body = ["invitationCode": code]
            return body.encode()
        case .dispatchJoinRoom(_, let roomDto):
            let body = roomDto
            return body.encode()
        }
    }

    var url: String {
        switch self {
        case .dispatchCreateRoom(let roomInfo):
            return self[.dispatchCreateRoom(roomInfo: roomInfo)]
        case .dispatchVerifyCode(let code):
            return self[.dispatchVerifyCode(code: code)]
        case .dispatchJoinRoom(let roomId, let memberDTO):
            return self[.dispatchJoinRoom(roomId: roomId, memberDTO: memberDTO)]
        }
    }
    
    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(UserDefaultStorage.accessToken)"

        return NetworkRequest(url: self.url,
                              headers: headers,
                              reqBody: self.requestBody,
                              reqTimeout: self.requestTimeOut,
                              httpMethod: self.httpMethod
        )
    }
}
