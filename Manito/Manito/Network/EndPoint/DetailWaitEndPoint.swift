//
//  DetailWaitEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailWaitEndPoint: URLRepresentable {
    case fetchWithFriend(roomId: String)
    case fetchWaitingRoomInfo(roomId: String)
    case patchStartManitto(roomId: String)
    case putRoomInfo(roomId: String, roomInfo: RoomDTO)
    case deleteRoom(roomId: String)
    case deleteLeaveRoom(roomId: String)

    var path: String {
        switch self {
        case .fetchWithFriend(let roomId):
            return "/rooms/\(roomId)/participants"
        case .fetchWaitingRoomInfo(let roomId):
            return "/rooms/\(roomId)"
        case .patchStartManitto(let roomId):
            return "/rooms/\(roomId)/state"
        case .putRoomInfo(let roomId, _):
            return "/rooms/\(roomId)"
        case .deleteRoom(let roomId):
            return "/rooms/\(roomId)"
        case .deleteLeaveRoom(let roomId):
            return "/rooms/\(roomId)/participants"
        }
    }
}

extension DetailWaitEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .fetchWithFriend:
            return .get
        case .fetchWaitingRoomInfo:
            return .get
        case .patchStartManitto:
            return .patch
        case .putRoomInfo:
            return .put
        case .deleteRoom:
            return .delete
        case .deleteLeaveRoom:
            return .delete
        }
    }

    var requestBody: Data? {
        switch self {
        case .fetchWithFriend:
            return nil
        case .fetchWaitingRoomInfo:
            return nil
        case .patchStartManitto:
            return nil
        case .putRoomInfo(_, let roomInfo):
            let body = ["title": roomInfo.title,
                        "capacity": roomInfo.capacity.description,
                        "startDate": roomInfo.startDate,
                        "endDate": roomInfo.endDate]
            return body.encode()
        case .deleteRoom:
            return nil
        case .deleteLeaveRoom:
            return nil
        }
    }

    var url: String {
        switch self {
        case .fetchWithFriend(let roomId):
            return self[.fetchWithFriend(roomId: roomId)]
        case .fetchWaitingRoomInfo(let roomId):
            return self[.fetchWaitingRoomInfo(roomId: roomId)]
        case .patchStartManitto(let roomId):
            return self[.patchStartManitto(roomId: roomId)]
        case .putRoomInfo(let roomId, let roomInfo):
            return self[.putRoomInfo(roomId: roomId, roomInfo: roomInfo)]
        case .deleteRoom(let roomId):
            return self[.deleteRoom(roomId: roomId)]
        case .deleteLeaveRoom(let roomId):
            return self[.deleteLeaveRoom(roomId: roomId)]
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
