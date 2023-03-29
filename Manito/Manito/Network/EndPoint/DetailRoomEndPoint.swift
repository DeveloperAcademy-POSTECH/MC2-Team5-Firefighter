//
//  DetailRoomEndPoint.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/29.
//

import Foundation

enum DetailRoomEndPoint: URLRepresentable {
    case fetchStartingRoomInfo(roomId: String)
    case fetchDoneRoomInfo(roomId: String)
    case fetchWithFriend(roomId: String)
    case fetchMemory(roomId: String)
    case deleteRoomByMember(roomId: String)
    case deleteRoomByOwner(roomId: String)

    var path: String {
        switch self {
        case .fetchStartingRoomInfo(let roomId):
            return "/rooms/\(roomId)"
        case .fetchDoneRoomInfo(let roomId):
            return "/rooms/\(roomId)"
        case .fetchWithFriend(let roomId):
            return "/rooms/\(roomId)/participants"
        case .fetchMemory(let roomId):
            return "/rooms/\(roomId)/memories"
        case .deleteRoomByMember(let roomId):
            return "/rooms/\(roomId)/participants"
        case .deleteRoomByOwner(let roomId):
            return "/rooms/\(roomId)"
        }
    }
}

extension DetailRoomEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .fetchStartingRoomInfo:
            return .get
        case .fetchDoneRoomInfo:
            return .get
        case .fetchWithFriend:
            return .get
        case .fetchMemory:
            return .get
        case .deleteRoomByMember:
            return .delete
        case .deleteRoomByOwner:
            return .delete
        }
    }

    var requestBody: Data? {
        switch self {
        case .fetchStartingRoomInfo:
            return nil
        case .fetchDoneRoomInfo:
            return nil
        case .fetchWithFriend:
            return nil
        case .fetchMemory:
            return nil
        case .deleteRoomByMember:
            return nil
        case .deleteRoomByOwner:
            return nil
        }
    }

    var url: String {
        switch self {
        case .fetchStartingRoomInfo(let roomId):
            return self[.fetchStartingRoomInfo(roomId: roomId)]
        case .fetchDoneRoomInfo(let roomId):
            return self[.fetchDoneRoomInfo(roomId: roomId)]
        case .fetchWithFriend(let roomId):
            return self[.fetchWithFriend(roomId: roomId)]
        case .fetchMemory(let roomId):
            return self[.fetchMemory(roomId: roomId)]
        case .deleteRoomByMember(let roomId):
            return self[.deleteRoomByMember(roomId: roomId)]
        case .deleteRoomByOwner(let roomId):
            return self[.deleteRoomByOwner(roomId: roomId)]
        }
    }

    func createRequest() -> NetworkRequest {
        return NetworkRequest(url: self.url,
                              reqBody: self.requestBody,
                              reqTimeout: self.requestTimeOut,
                              httpMethod: self.httpMethod
        )
    }
}
