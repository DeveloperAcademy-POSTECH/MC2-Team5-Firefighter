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
        return "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiLsvZTruYQiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTY2MjA0NDE4MSwiZXhwIjoxNjY5ODIwMTgxfQ.FxPw2G4PdlmsVZwVqu6wO03LxAWjU74gzKUxigUiajc"
    }
}
