//
//  LetterEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum LetterEndPoint: EndPointable {
    case dispatchLetter(roomId: String, image: Data?, letter: LetterDTO)
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
        case .dispatchLetter(_, let image, let letter):
            let boundary = generateBoundaryString()
            let id: String? = "eec7ef46-fa5a-4ba3-94d5-4985beabd4c2"
            
            let parameters: [String: String?] = ["manitteeId": id,
                                                 "messageContent": letter.messageContent]
            let dataBody = createDataBody(withParameters: parameters,
                                          media: image ?? nil,
                                          boundary: boundary)
            
            let stringValue = String(decoding: dataBody, as: UTF8.self)
            print(stringValue)
            
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
        case .dispatchLetter(let roomId,_,_):
            return "\(baseURL)/rooms/\(roomId)/messages-separate"
        case .fetchSendLetter(let roomId):
            return "\(baseURL)/rooms/\(roomId)/messages-sent"
        case .fetchReceiveLetter(let roomId):
            return "\(baseURL)/rooms/\(roomId)/messages-received"
        case .patchReadMessage(let roomId, _):
            return "\(baseURL)/rooms/\(roomId)/messages/status"
        }
    }
    
    func createRequest(environment: APIEnvironment) -> NetworkRequest {
        var headers: [String: String] = [:]
        let boundary = generateBoundaryString()
        
        switch self {
        case .dispatchLetter:
            headers["Content-Type"] = "multipart/form-data; boundary=\"\(boundary)\""
        default:
            headers["Content-Type"] = "application/json"
        }
        
        headers["authorization"] = "Bearer \(APIEnvironment.development.token)"
        return NetworkRequest(url: getURL(baseURL: environment.baseUrl),
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
            print("key : ", key)
            print("value : ", value)
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }

        if let media = media {
            let mediaKey = "image"
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(mediaKey)\"; filename=\"\(arc4random()).png\"\(lineBreak)")
            body.append("Content-Type: image/png \(lineBreak + lineBreak)")
            body.append(media)
            body.append(lineBreak)
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
