//
//  LetterEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum LetterEndPoint: EndPointable {
    case sendLetter(roomId: String, dto: SendMessageDTO)
    case getSendLetter(roomId: String)
    case getReceiveLetter(roomId: String)
    case changeReadMessage(roomId: String, status: String)

    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .sendLetter:
            return .post
        case .getSendLetter:
            return .get
        case .getReceiveLetter:
            return .get
        case .changeReadMessage:
            return .patch
        }
    }

    var requestBody: Data? {
        switch self {
        case .sendLetter(_, let dto):
            let body = dto
            return body.encode()
        case .getSendLetter:
            return nil
        case .getReceiveLetter:
            return nil
        case .changeReadMessage(_, let status):
            let body = ["status": status]
            return body.encode()
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .sendLetter(let roomId, _):
            return "\(baseURL)/api/rooms/\(roomId)/messages"
        case .getSendLetter(let roomId):
            return "\(baseURL)/api/rooms/\(roomId)/messages"
        case .getReceiveLetter(let roomId):
            return "\(baseURL)/api/rooms/\(roomId)/messages"
        case .changeReadMessage(let roomId, _):
            return "\(baseURL)/api/rooms/\(roomId)/messages/status"
        }
    }
}
