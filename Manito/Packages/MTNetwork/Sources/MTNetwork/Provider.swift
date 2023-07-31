//
//  Provider.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/17.
//

import Foundation

public struct Provider<T: Requestable>: Providable {

    ///  measure Network Time
    private var requestStartTime: Date?

    public init() {
        self.requestStartTime = nil
    }

    public mutating func request(_ request: T, didMeasureTime: Bool = false) async throws -> Response {
        self.requestStartTime = didMeasureTime ? Date() : nil

        let endpoint = self.endpoint(request)
        let urlRequest = try endpoint.urlRequest()

        self.willSend(urlRequest, request)

        let session = self.defaultSession(timeout: request.requestTimeout)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw MTError.invalidResponse
        }

        let responseData = self.response(data, response: httpResponse)

        switch httpResponse.statusCode {
        case (200..<300):
            self.didReceive(.success(responseData), request)
            return responseData
        case (300..<400):
            throw self.error(MTError.statusCode(reason: .noRedirect(responseData)), request)
        case (400..<500):
            throw self.error(MTError.statusCode(reason: .clientError(responseData)), request)
        case (500..<600):
            throw self.error(MTError.statusCode(reason: .serverError(responseData)), request)
        default:
            throw self.error(MTError.statusCode(reason: .invalidStatus(responseData)), request)
        }
    }
}

extension Provider {
    fileprivate func endpoint(_ request: Requestable) -> EndPoint {
        return EndPoint(url: URL(request: request).absoluteString,
                        method: request.method,
                        task: request.task,
                        httpHeaderFields: request.headers)
    }

    fileprivate func defaultSession(timeout: Float) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)

        return URLSession(configuration: configuration)
    }

    fileprivate func response(_ data: Data, response: HTTPURLResponse) -> Response {
        let statusCode = response.statusCode
        return Response(statusCode: statusCode,
                        response: response,
                        data: data)
    }
    
    fileprivate mutating func error(_ error: MTError, _ request: Requestable) -> MTError {
        self.didReceive(.failure(error), request)
        return error
    }
}

extension Provider {

    // MARK: - Private - Logger

    private func willSend(_ urlRequest: URLRequest, _ request: Requestable) {
        NetworkLogger().willSend(urlRequest, request)
    }

    private mutating func didReceive(_ result: Result<Response, MTError>, _ request: Requestable) {
        switch result {
        case .success(let success):
            NetworkLogger().didReceive(.success(success), request)
        case .failure(let failure):
            NetworkLogger().didReceive(.failure(failure), request)
        }
        self.measure(request)
    }

    private mutating func measure(_ request: Requestable) {
        if let requestStartTime = self.requestStartTime {
            NetworkLogger().measure(Date().timeIntervalSince(requestStartTime), request)
        }
        self.requestStartTime = nil
    }
}
