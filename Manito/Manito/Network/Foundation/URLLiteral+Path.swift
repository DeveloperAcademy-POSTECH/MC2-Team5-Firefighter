//
//  URLLiteral+Path.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/16.
//

import Foundation

extension URLLiteral {

    // MARK: - main path

    enum Main: String, RawRepresentable {
        case fetchCommonMission = "/missions/common/"
        case fetchManittoList = "/rooms/"
    }

    // MARK: - detailWait path

    enum DetailWait: String {
        case fetchCommonMission = "/missions/common/"
        case fetchManittoList = "/rooms/"

        static subscript(_ `case`: Self, version: APIEnvironment = .v1) -> String {
            return APIEnvironment.baseURL(version) + `case`.rawValue
        }
    }
}

extension RawRepresentable {
    static subscript(_ `case`: Self, version: APIEnvironment = .v1) -> String {
        return APIEnvironment.baseURL(version) + "\(`case`.rawValue)"
    }
}
