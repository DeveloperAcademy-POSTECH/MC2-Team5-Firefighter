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
            var body = Data()
            let boundary = generateBoundaryString()
            let boundaryPrefix = "--\(boundary)\r\n"
            let jsonEncoder = JSONEncoder()
            
            let imgDataKey = "image"
            if let image = image {
                body.append(boundaryPrefix.data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/png\r\n".data(using: .utf8)!)
                body.append(image)
                body.append("\r\n".data(using: .utf8)!)
            }
            
            let messageDataKey = "sendMessageRequest"
            let messageJsonData = try! jsonEncoder.encode(letter)
            let messageJson = String(data: messageJsonData, encoding: String.Encoding.utf8)
            if let json = messageJson {
                body.append(boundaryPrefix.data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(messageDataKey)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: application/json; charset=utf-8\r\n".data(using: .utf8)!)
                body.append("\(json)\r\n".data(using: .utf8)!)
                body.append(boundaryPrefix.data(using: .utf8)!)
            }
            
            return body
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
            return "\(baseURL)/rooms/\(roomId)/messages"
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
        let boundary = "Boundary-\(UUID().uuidString)"
        
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
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
