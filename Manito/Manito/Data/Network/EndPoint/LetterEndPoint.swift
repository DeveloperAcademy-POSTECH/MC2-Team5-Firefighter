//
//  LetterEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

import MTNetwork

enum LetterEndPoint {
    case dispatchLetter(roomId: String, image: Data?, letter: LetterRequestDTO, missionId: String)
    case fetchSendLetter(roomId: String)
    case fetchReceiveLetter(roomId: String)
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
        }
    }

    var task: HTTPTask {
        switch self {
        case .dispatchLetter(_, let image, let letter, let missionId):
            var multipartData: [MultipartFormData] = []
            if let image {
                let imageData = MultipartFormData(provider: .data(image),
                                                  name: "image",
                                                  filename: "\(arc4random())",
                                                  mimeType: "image/jpeg")
                multipartData.append(imageData)
            }
            let parameters: [String: Any] = ["manitteeId": letter.manitteeId,
                                             "messageContent": letter.messageContent ?? "",
                                             "missionId": missionId]
            let parametersData = MultipartFormData(provider: .parameter(parameters))
            multipartData.append(parametersData)
            return .uploadMultipart(multipartData)
        case .fetchSendLetter:
            return .requestPlain
        case .fetchReceiveLetter:
            return .requestPlain
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
