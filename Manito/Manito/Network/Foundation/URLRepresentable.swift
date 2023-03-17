//
//  URLRepresentable.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/17.
//

import Foundation

protocol URLRepresentable {
    var path: String { get }
}

extension URLRepresentable {
    subscript(_ `case`: Self, version: APIEnvironment = .v1) -> String {
        return APIEnvironment.baseURL(version) + "\(`case`.path)"
    }
}
