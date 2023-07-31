//
//  Providable.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/17.
//

import Foundation

public protocol Providable {
    associatedtype T: Requestable
    mutating func request(_ request: T, didMeasureTime: Bool) async throws -> Response
}
