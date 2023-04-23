//
//  LetterEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum LetterEndPoint: URLRepresentable {
    case dispatchLetter(roomId: String, image: Data?, letter: LetterDTO, missionId: String)
    case fetchSendLetter(roomId: String)
    case fetchReceiveLetter(roomId: String)
    case patchReadMessage(roomId: String, status: String)

    var path: String {
        switch self {
        case .dispatchLetter(let roomId, _, _, _):
            return "/rooms/\(roomId)/messages-separate"
        case .fetchSendLetter(let roomId):
            return "/rooms/\(roomId)/messages-sent"
        case .fetchReceiveLetter(let roomId):
            return "/rooms/\(roomId)/messages-received"
        case .patchReadMessage(let roomId, _):
            return "/rooms/\(roomId)/messages/status"
        }
    }
}

extension LetterEndPoint: EndPointable {
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

    var url: String {
        switch self {
        case .dispatchLetter(let roomId, let image, let letterDTO, let missionId):
            return self[.dispatchLetter(roomId: roomId, image: image, letter: letterDTO, missionId: missionId)]
        case .fetchSendLetter(let roomId):
            return self[.fetchSendLetter(roomId: roomId), .v2]
        case .fetchReceiveLetter(let roomId):
            return self[.fetchReceiveLetter(roomId: roomId), .v2]
        case .patchReadMessage(let roomId, let status):
            return self[.patchReadMessage(roomId: roomId, status: status)]
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
        
        return NetworkRequest(url: self.url,
                              headers: headers,
                              reqBody: self.requestBody,
                              reqTimeout: self.requestTimeOut,
                              httpMethod: self.httpMethod)
    }
}

// MARK: - Multipart Form Data Helper Method
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
