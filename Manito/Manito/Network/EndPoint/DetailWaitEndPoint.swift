//
//  DetailWaitEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailWaitEndPoint: EndPointable {
    case fetchWithFriend(roomId: String)
    case fetchWaitingRoomInfo(roomId: String)
    case patchStartManitto(roomId: String)
    case putRoomInfo(roomId: String, roomInfo: RoomDTO)
    case deleteRoom(roomId: String)
    case deleteLeaveRoom(roomId: String)

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

    func getURL(baseURL: String) -> String {
        switch self {
        case .fetchWithFriend(let roomId):
            return URLLiteral.DetailWait[.fetchWithFriend(roomId: roomId)]
        case .fetchWaitingRoomInfo(let roomId):
            return URLLiteral.DetailWait[.fetchWaitingRoomInfo(roomId: roomId)]
        case .patchStartManitto(let roomId):
            return URLLiteral.DetailWait[.patchStartManitto(roomId: roomId)]
        case .putRoomInfo(let roomId, _):
            return URLLiteral.DetailWait[.putRoomInfo(roomId: roomId)]
        case .deleteRoom(let roomId):
            return URLLiteral.DetailWait[.deleteRoom(roomId: roomId)]
        case .deleteLeaveRoom(let roomId):
            return URLLiteral.DetailWait[.deleteLeaveRoom(roomId: roomId)]
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
