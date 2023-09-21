//
//  RoomEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

import MTNetwork

enum RoomParticipationEndPoint {
    case dispatchCreateRoom(room: CreatedRoomRequestDTO)
    case dispatchVerifyCode(code: String)
    case dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO)
}

extension RoomParticipationEndPoint: Requestable {
    var baseURL: URL {
        return APIEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .dispatchCreateRoom:
            return "/v1/rooms"
        case .dispatchVerifyCode:
            return "/v1/invitations/verification"
        case .dispatchJoinRoom(let roomId, _):
            return "/v1/rooms/\(roomId)/participants"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .dispatchCreateRoom:
            return .post
        case .dispatchVerifyCode:
            return .post
        case .dispatchJoinRoom:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .dispatchCreateRoom(let room):
            return .requestJSONEncodable(room)
        case .dispatchVerifyCode(let code):
            let body = ["invitationCode": code]
            return .requestJSONEncodable(body)
        case .dispatchJoinRoom(_, let member):
            return .requestJSONEncodable(member)
        }
    }

    var headers: HTTPHeaders {
        let headers: [HTTPHeader] = [
            HTTPHeader.contentType("application/json"),
            HTTPHeader.authorization(bearerToken: UserDefaultStorage.accessToken)
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
