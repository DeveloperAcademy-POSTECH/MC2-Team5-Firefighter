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
            return "\(baseURL)/rooms/\(roomId)/participants"
        case .fetchWaitingRoomInfo(let roomId):
            return "\(baseURL)/rooms/\(roomId)"
        case .patchStartManitto(let roomId):
            return "\(baseURL)/rooms/\(roomId)/state"
        case .putRoomInfo(let roomId, _):
            return "\(baseURL)/rooms/\(roomId)"
        case .deleteRoom(let roomId):
            return "\(baseURL)/rooms/\(roomId)"
        case .deleteLeaveRoom(let roomId):
            return "\(baseURL)/rooms/\(roomId)/participants"
        }
    }
    
    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(UserDefaultStorage.accessToken)"
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseUrl),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod
        )
    }
}
