//
//  APIEnvironment.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum APIEnvironment {
    case v1, v2

    static func baseURL(_ version: Self = v1) -> String {
        return URLLiteral.productionUrl + "/api/\(version)"
    }
    
    static let boundary: String = "com.TeamFirefighter.Manito"
}
