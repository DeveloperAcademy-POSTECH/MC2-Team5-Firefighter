//
//  APIEnvironment.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum APIEnvironment {
    static let baseUrl: String = UrlLiteral.developmentUrl
    static let token: String = UserDefaultStorage.accessToken
    static let boundary: String = "com.TeamFirefighter.Manito"
}
