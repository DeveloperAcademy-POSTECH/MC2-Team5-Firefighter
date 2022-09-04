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
        return "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0b2tlbnRva2VuIiwicm9sZSI6IlVTRVIiLCJpYXQiOjE2NjAyMDI0MjEsImV4cCI6MTY2Nzk3ODQyMX0.T2bf5BA-81Dc_snRFeP9_Z9xnWLptABtQIeT_smIVPo"
    }
}
