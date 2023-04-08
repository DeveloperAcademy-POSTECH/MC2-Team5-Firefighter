//
//  APIEnvironment.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum APIEnvironment: String {
    case v1 = "/v1"
    case v2 = "/v2"
    case none = ""

    static func baseURL(_ version: Self = v1) -> String {
        return URLLiteral.productionUrl + "/api\(version.rawValue)"
    }
    
    static let boundary: String = "com.TeamFirefighter.Manito"
}
