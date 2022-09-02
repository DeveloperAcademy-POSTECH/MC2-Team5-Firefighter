//
//  DetailWaitEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailWaitEndPoint: EndPointable {
    case getWithFriend(roomId: String)
    case getWaitingRoomInfo(roomId: String)
    case startManitto(roomId: String)
    case editRoomInfo(roomId: String, roomInfo: RoomDTO)
    case deleteRoom(roomId: String)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getWithFriend:
            return .get
        case .getWaitingRoomInfo:
            return .get
        case .startManitto:
            return .patch
        case .editRoomInfo:
            return .put
        case .deleteRoom:
            return .delete
        }
    }

    var requestBody: Data? {
        switch self {
        case .getWithFriend:
            return nil
        case .getWaitingRoomInfo:
            return nil
        case .startManitto:
            return nil
        case .editRoomInfo(_, let roomInfo):
            let body = ["title": roomInfo.title,
                        "capacity": roomInfo.capacity.description,
                        "startDate": roomInfo.startDate,
                        "endDate": roomInfo.endDate]
            return body.encode()
        case .deleteRoom:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .getWithFriend(let roomId):
            return "\(baseURL)/rooms/\(roomId)/participants"
        case .getWaitingRoomInfo(let roomId):
            return "\(baseURL)/rooms/\(roomId)"
        case .startManitto(let roomId):
            return "\(baseURL)/rooms/\(roomId)/state"
        case .editRoomInfo(let roomId, _):
            return "\(baseURL)/rooms/\(roomId)"
        case .deleteRoom(let roomId):
            return "\(baseURL)/rooms/\(roomId)"
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
