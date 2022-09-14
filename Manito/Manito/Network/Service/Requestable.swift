//
//  Requestable.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/08/31.
//

import Foundation

protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> T?
    func request(_ request: NetworkRequest) async throws -> Int
    func requestCreateRoom(_ request: NetworkRequest) async throws -> Int?
}
