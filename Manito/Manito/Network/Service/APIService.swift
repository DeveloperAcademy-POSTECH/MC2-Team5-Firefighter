//
//  APIService.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

final class APIService: Requestable {
    
    var requestTimeOut: Float = 30

    func request<T: Decodable>(_ request: NetworkRequest) async throws -> T? {
        let (data, httpResponse) = try await requestDataToUrl(request)
        
        switch httpResponse.statusCode {
        case (200..<300):
            let decoder = JSONDecoder()
            let baseModelData: T? = try decoder.decode(T.self, from: data)
            return baseModelData
        case (300..<500):
            throw NetworkError.clientError(message: httpResponse.statusCode.description)
        default:
            throw NetworkError.serverError
        }
    }
    
    func request(_ request: NetworkRequest) async throws -> Int {
        let (_, httpResponse) = try await requestDataToUrl(request)
        
        switch httpResponse.statusCode {
        case (200..<300):
            return httpResponse.statusCode
        case (300..<500):
            throw NetworkError.clientError(message: httpResponse.statusCode.description)
        default:
            throw NetworkError.serverError
        }
    }
    
    func requestCreateRoom(_ request: NetworkRequest) async throws -> Int? {
        let (_, httpResponse) = try await requestDataToUrl(request)
        
        switch httpResponse.statusCode {
        case (200..<300):
            let responseUrl = httpResponse.value(forHTTPHeaderField: "Location")
            return responseUrl?.roomId
        case (300..<500):
            throw NetworkError.clientError(message: httpResponse.statusCode.description)
        default:
            throw NetworkError.serverError
        }
    }
}

extension APIService {
    typealias UrlResponse = (Data, HTTPURLResponse)
    
    private func requestDataToUrl(_ request: NetworkRequest) async throws -> UrlResponse {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(request.requestTimeOut ?? requestTimeOut)
        guard let encodedUrl = request.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrl) else {
            throw NetworkError.encodingError
        }
        print("encodedUrl = \(encodedUrl)")

        let (data, response) = try await URLSession.shared.data(for: request.buildURLRequest(with: url))
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.serverError }
        
        return (data, httpResponse)
    }
}

private extension String {
    var roomId: Int? {
        guard let id = self.split(separator: "/").last.map({ Int($0) }) else { return nil }
        return id
    }
}
