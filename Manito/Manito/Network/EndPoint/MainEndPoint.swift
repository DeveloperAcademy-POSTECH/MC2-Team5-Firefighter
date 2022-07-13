//
//  MainEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/10.
//

import Foundation

enum MainEndPoint: EndPointable {
    case getCommonMission
    case getManittoList(page: String, perPage: String)
    case getRoomStateCheck(roomId: String)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getCommonMission:
            return .get
        case.getManittoList:
            return .get
        case.getRoomStateCheck:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .getCommonMission:
            return nil
        case .getManittoList:
            return nil
        case .getRoomStateCheck:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .getCommonMission:
            return "\(baseURL)/api/missions/"
        case .getManittoList(let page, let perPage):
            return "\(baseURL)/api/rooms?page=\(page)&per_page=\(perPage)"
        case .getRoomStateCheck(let roomId):
            return "\(baseURL)/api/rooms/\(roomId)/state"
        }
    }
}
