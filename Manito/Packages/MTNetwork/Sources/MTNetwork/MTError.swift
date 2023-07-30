//
//  MTError.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/17.
//

import Foundation

public enum MTError: Error {
    
    ///  failed to create a valid `URL`.
    case invalidURL(error: Error)

    ///  failed to encode multipart form data.
    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)

    ///  failed to encode parameter.
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)

    ///  failed to decode response.
    case responseDecodingFailed(Response)

    ///  failed to response a valid `HTTPURLResponse`.
    case invalidResponse

    ///  response failed with an invalid HTTP status code.
    case statusCode(reason: StatusCodeReason)

    ///  The underlying reason the `.multipartEncodingFailed` error occurred.
    public enum MultipartEncodingFailureReason {
        case invalidData
        case dataEncodingFailure
    }

    ///  The underlying reason the `.parameterEncodingFailed` error occurred.
    public enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailure(error: Error)
    }

    ///  The underlying reason the `.statusCode` error occurred.
    public enum StatusCodeReason {
        case noRedirect(Response)
        case clientError(Response)
        case serverError(Response)
        case invalidStatus(Response)
    }
}

extension MTError {
    public var response: MTNetwork.Response? {
        switch self {
        case .invalidURL: return nil
        case .multipartEncodingFailed: return nil
        case .parameterEncodingFailed: return nil
        case .responseDecodingFailed(let response): return response
        case .invalidResponse: return nil
        case .statusCode(let reason):
            switch reason {
            case .noRedirect(let response): return response
            case .clientError(let response): return response
            case .serverError(let response): return response
            case .invalidStatus(let response): return response
            }
        }
    }
}

extension MTError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let error):
            return "⛔️ 유효하지 않은 URL 입니다. URL를 확인해주세요.\n" + "⛔️ error: \(error.localizedDescription)"
        case .multipartEncodingFailed(let reason):
            return reason.errorDescription
        case .parameterEncodingFailed(let reason):
            return reason.errorDescription
        case .responseDecodingFailed:
            return "⛔️ response를 decode할 수 없습니다.\n"
        case .statusCode(let reason):
            return reason.errorDescription
        case .invalidResponse:
            return "⛔️ 유효하지 않은 HTTPURLResponse 입니다.\n"
        }
    }
}

extension MTError.MultipartEncodingFailureReason: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "⛔️ 유효하지 않은 데이터입니다."
        case .dataEncodingFailure:
            return "⛔️ response를 decode할 수 없습니다."
        }
    }
}

extension MTError.ParameterEncodingFailureReason: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingURL:
            return "⛔️ missing URL로 URLRequest가 encode 되었습니다."
        case .jsonEncodingFailure(let error):
            return "⛔️ JSON 형식으로 encode할 수 없습니다.\n" + "⛔️ error: \(error.localizedDescription)"
        }
    }
}

extension MTError.StatusCodeReason: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noRedirect:
            return "⛔️ 300..<400 코드가 들어왔습니다."
        case .clientError:
            return "⛔️ 400..<500 코드가 들어왔습니다."
        case .serverError:
            return "⛔️ server에서 문제가 발생했습니다."
        case .invalidStatus:
            return "⛔️ 유효하지 않은 상태 코드가 들어왔습니다."
        }
    }
}
