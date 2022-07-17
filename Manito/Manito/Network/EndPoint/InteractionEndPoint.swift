//
//  InteractionEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum InteractionEndPoint: EndPointable {
    case mixRandomManitto(roomId: String)
    case openManitto

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .mixRandomManitto:
            return .post
        case .openManitto:
            return .get
        }
    }

    var requestBody: Data? {
        switch self {
        case .mixRandomManitto:
            return nil
        case .openManitto:
            return nil
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .mixRandomManitto(let roomId):
            return "\(baseURL)/api/rooms/\(roomId)/relations"
        case .openManitto:
            return "\(baseURL)/api/relations/my-manitto"
        }
    }
}
