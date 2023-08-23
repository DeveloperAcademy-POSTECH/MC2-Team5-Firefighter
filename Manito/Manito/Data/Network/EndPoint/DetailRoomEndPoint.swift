//
//  DetailRoomEndPoint.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/23.
//

import Foundation

import MTNetwork

enum DetailRoomEndPoint {
    case fetchWithFriend(roomId: String)
    case fetchRoomInfo(roomId: String)
    case fetchResetMission(roomId: String)
    case fetchMemory(roomId: String)
    case patchStartManitto(roomId: String)
    case patchEditMission(roomId: String, body: MissionDTO)
    case putRoomInfo(roomId: String, roomInfo: RoomDTO)
    case deleteRoom(roomId: String)
    case deleteLeaveRoom(roomId: String)
}

extension DetailRoomEndPoint: Requestable {
    var baseURL: URL {
        return APIEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .fetchWithFriend(let roomId):
            return "/v1/rooms/\(roomId)/participants"
        case .fetchRoomInfo(let roomId):
            return "/v1/rooms/\(roomId)"
        case .fetchResetMission(let roomId):
            return "/v1/\(roomId)/individual-mission/restore"
        case .fetchMemory(let roomId):
            return "/v1/rooms/\(roomId)/memories"
        case .patchStartManitto(let roomId):
            return "/v1/rooms/\(roomId)/state"
        case .patchEditMission(let roomId, _):
            return "/v1/\(roomId)/individual-mission"
        case .putRoomInfo(let roomId, _):
            return "/v1/rooms/\(roomId)"
        case .deleteRoom(let roomId):
            return "/v1/rooms/\(roomId)"
        case .deleteLeaveRoom(let roomId):
            return "/v1/rooms/\(roomId)/participants"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchWithFriend:
            return .get
        case .fetchRoomInfo:
            return .get
        case .fetchResetMission:
            return .get
        case .fetchMemory:
            return .get
        case .patchStartManitto:
            return .patch
        case .patchEditMission:
            return .patch
        case .putRoomInfo:
            return .put
        case .deleteRoom:
            return .delete
        case .deleteLeaveRoom:
            return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .fetchWithFriend:
            return .requestPlain
        case .fetchRoomInfo:
            return .requestPlain
        case .fetchResetMission:
            return .requestPlain
        case .fetchMemory:
            return .requestPlain
        case .patchStartManitto:
            return .requestPlain
        case .patchEditMission(_, let body):
            return .requestJSONEncodable(body)
        case .putRoomInfo(_, let roomInfo):
            let body = ["title": roomInfo.title,
                        "capacity": roomInfo.capacity.description,
                        "startDate": roomInfo.startDate,
                        "endDate": roomInfo.endDate]
            return .requestJSONEncodable(body)
        case .deleteRoom:
            return .requestPlain
        case .deleteLeaveRoom:
            return .requestPlain
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
