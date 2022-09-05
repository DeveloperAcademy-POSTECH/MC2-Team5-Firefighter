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
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(request.requestTimeOut ?? requestTimeOut)
        guard let encodedUrl = request.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrl) else {
            throw NetworkError.encodingError
        }
        print("encodedUrl = \(encodedUrl)")

        let (data, response) = try await URLSession.shared.data(for: request.buildURLRequest(with: url))
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.serverError }
        switch httpResponse.statusCode {
        case (200..<300):
            let decoder = JSONDecoder()
            let baseModelData: T? = try decoder.decode(T.self, from: data)
            return baseModelData
        case (300..<500):
            throw NetworkError.clientError(message: "\(httpResponse.statusCode)")
        default:
            throw NetworkError.serverError
        }
    }
}
