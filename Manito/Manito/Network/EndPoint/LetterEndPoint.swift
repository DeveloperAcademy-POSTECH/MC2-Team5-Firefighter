//
//  LetterEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum LetterEndPoint: EndPointable {
    case dispatchLetter(roomId: String, image: Data?, letter: LetterDTO, missionId: String)
    case fetchSendLetter(roomId: String)
    case fetchReceiveLetter(roomId: String)
    case patchReadMessage(roomId: String, status: String)
    
    var requestTimeOut: Float {
        return 20
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .dispatchLetter:
            return .post
        case .fetchSendLetter:
            return .get
        case .fetchReceiveLetter:
            return .get
        case .patchReadMessage:
            return .patch
        }
    }

    var requestBody: Data? {
        switch self {
        case .dispatchLetter(_, let image, let letter, let missionId):
            let parameters: [String: String?] = ["manitteeId": letter.manitteeId,
                                                 "messageContent": letter.messageContent,
                                                 "missionId": missionId]
            let dataBody = createDataBody(withParameters: parameters,
                                          media: image ?? nil,
                                          boundary: APIEnvironment.boundary)
            return dataBody
        case .fetchSendLetter:
            return nil
        case .fetchReceiveLetter:
            return nil
        case .patchReadMessage(_, let status):
            let body = ["status": status]
            return body.encode()
        }
    }

    func getURL(baseURL: String) -> String {
        switch self {
        case .dispatchLetter(let roomId,_,_,_):
            return "\(baseURL)/rooms/\(roomId)/messages-separate"
        case .fetchSendLetter(let roomId):
            return "https://dev.aenitto.shop/api/v2/rooms/\(roomId)/messages-sent"
        case .fetchReceiveLetter(let roomId):
            return "https://dev.aenitto.shop/api/v2/rooms/\(roomId)/messages-received"
        case .patchReadMessage(let roomId, _):
            return "\(baseURL)/rooms/\(roomId)/messages/status"
        }
    }
    
    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        
        switch self {
        case .dispatchLetter:
            headers["Content-Type"] = "multipart/form-data; boundary=\(APIEnvironment.boundary)"
        default:
            headers["Content-Type"] = "application/json"
        }
        
        headers["Authorization"] = "Bearer \(UserDefaultStorage.accessToken)"
        
        return NetworkRequest(url: getURL(baseURL: APIEnvironment.baseUrl),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod)
    }
}

extension LetterEndPoint {
    func createDataBody(withParameters params: [String: String?],
                        media: Data?,
                        boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        for (key, value) in params {
            guard let value = value else { continue }
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }

        if let media = media {
            let mediaKey = "image"
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(mediaKey)\"; filename=\"\(arc4random()).jpeg\"\(lineBreak)")
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
            body.append(media)
            body.append(lineBreak)
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
