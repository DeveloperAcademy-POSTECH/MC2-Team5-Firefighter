//
//  NetworkError.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

enum NetworkError: Error {
    case encodingError
    case clientError(message: String?)
    case serverError
    case unknownError
}
