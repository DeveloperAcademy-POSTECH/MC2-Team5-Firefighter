//
//  MissionEditEndPoint.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/06/25.
//

import Foundation

enum MissionEditEndPoint: URLRepresentable {
    case patchEditMission(roomId: String, body: MissionDTO)
    
    
    var path: String {
        switch self {
        case .patchEditMission(let roomId, _):
            return "/\(roomId)/individual-mission"
        }
    }
}

extension MissionEditEndPoint: EndPointable {
    var requestTimeOut: Float {
        return 20
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .patchEditMission:
            return .patch
        }
    }
    
    var requestBody: Data? {
        switch self {
        case .patchEditMission(_, let body):
            return body.encode()
        }
    }
    
    var url: String {
        switch self {
        case .patchEditMission(let roomId, let body):
            return self[.patchEditMission(roomId: roomId, body: body)]
        }
    }
    
    func createRequest() -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["authorization"] = "Bearer \(UserDefaultStorage.accessToken)"

        return NetworkRequest(url: self.url,
                              headers: headers,
                              reqBody: self.requestBody,
                              reqTimeout: self.requestTimeOut,
                              httpMethod: self.httpMethod
        )
    }
}