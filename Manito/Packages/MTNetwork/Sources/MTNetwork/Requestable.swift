//
//  Requestable.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/17.
//

import Foundation

public protocol Requestable {

    ///  Request's base `URL`.
    var baseURL: URL { get }

    ///  The path to be appended to `baseURL` to form the full `URL`
    var path: String { get }

    ///  The HTTP method used in the request.
    var method: HTTPMethod { get }

    ///  The type of HTTP task to be performed.
    var task: HTTPTask { get }

    ///  The headers to be used in the request.
    var headers: HTTPHeaders { get }

    ///  The timeout interval of the request. Default is `60.0`
    var requestTimeout: Float { get }

    ///  Provides stub data for use in testing. Default is `Data()`
    var sampleData: Data? { get }
}

extension Requestable {
    var requestTimeout: Float { 60.0 }
    var sampleData: Data? { Data() }
}
