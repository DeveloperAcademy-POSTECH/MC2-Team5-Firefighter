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
        return UserData.getValue(forKey: .accessToken) ?? ""
    }
}
