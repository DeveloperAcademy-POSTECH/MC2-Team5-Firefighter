//
//  APIEnvironment.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum APIEnvironment: String, CaseIterable {
    case development
    case production
}

extension APIEnvironment {
    var baseUrl: String {
        switch self {
        case .development:
            return "http://43.200.81.247:8080/api/v1"
        case .production:
            return ""
        }
    }
    
    var token: String {
        return "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiLsnoTsi5wg7IKs7Jqp7J6QMSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNjYyMDI1NDY5LCJleHAiOjE2Njk4MDE0Njl9.ccAT9zgCnl4KBE7eoQmiMLoWl3G0kVAwc7smz7hLghw"
    }
}
