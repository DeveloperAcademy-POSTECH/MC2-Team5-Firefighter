//
//  NetworkRequest.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

struct NetworkRequest {
    let url: String
    let body: Data?
    let requestTimeOut: Float?
    let httpMethod: HTTPMethod

    init(url: String,
        reqBody: Data? = nil,
        reqTimeout: Float? = nil,
        httpMethod: HTTPMethod
    ) {
        self.url = url
        self.body = reqBody
        self.requestTimeOut = reqTimeout
        self.httpMethod = httpMethod
    }

    func buildURLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer " + APIEnvironment.development.token, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = body
        return urlRequest
    }
}
