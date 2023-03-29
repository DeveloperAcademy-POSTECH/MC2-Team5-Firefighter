//
//  DetailDoneEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum DetailDoneEndPoint: URLRepresentable {
    case fetchWithFriend(roomId: String)
    case fetchMemory(roomId: String)
    case fetchDoneRoomInfo(roomId: String)
    case deleteRoomByMember(roomId: String)
    case deleteRoomByOwner(roomId: String)

    var path: String {
        switch self {
        case .fetchWithFriend(let roomId):
            return "/rooms/\(roomId)/participants"
        case .fetchMemory(let roomId):
            return "/rooms/\(roomId)/memories"
        case .fetchDoneRoomInfo(let roomId):
            return "/rooms/\(roomId)"
        case .deleteRoomByMember(let roomId):
            return "/rooms/\(roomId)/participants"
        case .deleteRoomByOwner(let roomId):
            return "/rooms/\(roomId)"
        }
    }
}

extension DetailDoneEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .fetchWithFriend:
            return .get
        case .fetchMemory:
            return .get
        case .fetchDoneRoomInfo:
            return .get
        case .deleteRoomByMember:
            return .delete
        case .deleteRoomByOwner:
            return .delete
        }
    }

    var requestBody: Data? {
        switch self {
        case .fetchWithFriend:
            return nil
        case .fetchMemory:
            return nil
        case .fetchDoneRoomInfo:
            return nil
        case .deleteRoomByMember:
            return nil
        case .deleteRoomByOwner:
            return nil
        }
    }

    var url: String {
        switch self {
        case .fetchWithFriend(let roomId):
            return self[.fetchWithFriend(roomId: roomId)]
        case .fetchMemory(let roomId):
            return self[.fetchMemory(roomId: roomId)]
        case .fetchDoneRoomInfo(let roomId):
            return self[.fetchDoneRoomInfo(roomId: roomId)]
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
