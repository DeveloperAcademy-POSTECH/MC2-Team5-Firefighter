//
//  Endpointable.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/10.
//

import Foundation

protocol EndPointable {
    var requestTimeOut: Float { get }
    var httpMethod: HTTPMethod { get }
    var requestBody: Data? { get }
    var url: String { get }
}
