//
//  URLRepresentable.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/17.
//

import Foundation

///
/// URL에 Path Variable, Query String를 추가하는 경우에
/// URLRepresentable를 사용해서 enum 타입이 String RawValue를 가지도록 만듭니다.
///

protocol URLRepresentable: RawRepresentable where RawValue == String { }

extension URLRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        default: return nil
        }
    }
}

extension RawRepresentable {
    static subscript(_ `case`: Self, version: APIEnvironment = .v1) -> String {
        return APIEnvironment.baseURL(version) + "\(`case`.rawValue)"
    }
}
