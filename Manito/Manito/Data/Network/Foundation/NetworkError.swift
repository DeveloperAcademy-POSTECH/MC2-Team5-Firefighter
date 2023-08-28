//
//  NetworkError.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

///
/// 프로젝트에 존재하는 모든 NetworkError가 사라지면 삭제하겠습니다.
///

enum NetworkError: Error {
    case encodingError
    case clientError(message: String?)
    case serverError
    case unknownError
}
