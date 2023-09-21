//
//  URLRequest+MTNetwork.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/17.
//

import Foundation

public extension URLRequest {

    typealias Parameters = [String: Any]

    ///  Encodes the type that complies with the `Encodable` protocol into `Data`.
    ///  Use `Data` as HTTP Body.
    mutating func encode(encodable: Encodable) throws -> URLRequest {
        do {
            let bodyData = try JSONEncoder().encode(encodable)
            self.httpBody = bodyData

            let contentTypeHeaderField = "Content-Type"
            if self.value(forHTTPHeaderField: contentTypeHeaderField) == nil {
                self.setValue("application/json", forHTTPHeaderField: contentTypeHeaderField)
            }

            return self
        } catch let error {
            throw MTError.parameterEncodingFailed(reason: .jsonEncodingFailure(error: error))
        }
    }

    ///  Insert parameter into URL Query.
    mutating func encode(parameters: Parameters) throws -> URLRequest {
        guard let url = self.url else {
            throw MTError.parameterEncodingFailed(reason: .missingURL)
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let queryItems: [URLQueryItem] = parameters.compactMap { URLQueryItem(name: $0, value: "\($1)") }
            urlComponents.queryItems = queryItems
            self.url = urlComponents.url!

            return self
        } else {
            return self
        }
    }

    ///  Encodes the `MultipartFormData` type  into `Data`.
    ///  Use `Data` as HTTP Body.
    mutating func encode(data: [MultipartFormData]) throws -> URLRequest {
        do {
            let multipartformWrapper = MultipartFormDataWrapper(data: data)
            let body = try multipartformWrapper.encode()
            self.httpBody = body

            let contentTypeHeaderField = "Content-Type"
            let contentTypeHeaderValue = multipartformWrapper.contentType
            self.setValue(contentTypeHeaderValue, forHTTPHeaderField: contentTypeHeaderField)

            return self
        } catch {
            throw MTError.multipartEncodingFailed(reason: .dataEncodingFailure)
        }
    }
}
