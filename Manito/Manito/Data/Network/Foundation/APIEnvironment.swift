//
//  APIEnvironment.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

enum APIEnvironment {
    #if DEV
    static let baseURL: URL = URL(string: Bundle.main.developmentURL)!
    #elseif PROD
    static let baseURL: URL = URL(string: Bundle.main.productionURL)!
    #endif
}
