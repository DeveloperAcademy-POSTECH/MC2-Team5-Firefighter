//
//  URL+MTNetwork.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/17.
//

import Foundation

public extension URL {

    ///  Create URL with path
    init<T: Requestable>(request: T) {
        let path = request.path
        if path.isEmpty {
            self = request.baseURL
        } else {
            self = URL(string: request.baseURL.absoluteString + path)!
        }
    }
}
