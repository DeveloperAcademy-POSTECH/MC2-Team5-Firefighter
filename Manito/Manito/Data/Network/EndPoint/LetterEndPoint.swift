//
//  LetterEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

import MTNetwork

enum LetterEndPoint {
    case dispatchLetter(roomId: String, image: Data?, letter: LetterDTO, missionId: String)
    case fetchSendLetter(roomId: String)
    case fetchReceiveLetter(roomId: String)
    case patchReadMessage(roomId: String, status: String)
}

extension LetterEndPoint: Requestable {
    var baseURL: URL {
        return APIEnvironment.baseURL
    }

    var path: String {
        switch self {
        case .dispatchLetter(let roomId, _, _, _):
            return "/v1/rooms/\(roomId)/messages-separate"
        case .fetchSendLetter(let roomId):
            return "/v2/rooms/\(roomId)/messages-sent"
        case .fetchReceiveLetter(let roomId):
            return "/v2/rooms/\(roomId)/messages-received"
        case .patchReadMessage(let roomId, _):
            return "/v1/rooms/\(roomId)/messages/status"
        }
    }

    var method: HTTPMethod {
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

    var task: HTTPTask {
        switch self {
        case .dispatchLetter(_, let image, let letter, let missionId):
            var multipartData: [MultipartFormData] = []
            if let image {
                let imageData = MultipartFormData(provider: .data(image),
                                                  name: "image",
                                                  filename: "\(arc4random()).jpeg",
                                                  mimeType: "image/jpeg")
                multipartData.append(imageData)
            }
            let parameters: [String: String?] = ["manitteeId": letter.manitteeId,
                                                 "messageContent": letter.messageContent,
                                                 "missionId": missionId]
            let parametersData = MultipartFormData(provider: .parameter(parameters))
            multipartData.append(parametersData)
            return .uploadMultipart(multipartData)
        case .fetchSendLetter:
            return .requestPlain
        case .fetchReceiveLetter:
            return .requestPlain
        case .patchReadMessage(_, let status):
            let body = ["status": status]
            return .requestJSONEncodable(body)
        }
    }

    var headers: HTTPHeaders {
        var headers: [HTTPHeader] = [
            HTTPHeader.authorization(bearerToken: UserDefaultStorage.accessToken)
        ]
        switch self {
        case .dispatchLetter:
            let contentType = HTTPHeader.contentType("multipart/form-data")
            headers.append(contentType)
        default:
            let contentType = HTTPHeader.contentType("application/json")
            headers.append(contentType)
        }
        return HTTPHeaders(headers)
    }

    var requestTimeout: Float {
        return 10
    }

    var sampleData: Data? {
        return nil
    }
}
