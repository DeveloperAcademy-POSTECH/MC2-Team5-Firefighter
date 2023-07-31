//
//  NetworkLogger.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/18.
//

import Foundation

public struct NetworkLogger {

    let configuration: Configuration

    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }
}

extension NetworkLogger {
    public func willSend(_ urlRequest: URLRequest, _ request: Requestable) {
        self.logNetworkRequest(urlRequest, request) { output in
            self.configuration.output(request, output)
        }
    }

    public func didReceive(_ result: Result<Response, MTError>, _ request: Requestable) {
        switch result {
        case .success(let success):
            self.configuration.output(request, self.logNetworkResponse(success, request))
        case .failure(let failure):
            self.configuration.output(request, self.logNetworkError(failure, request))
        }
    }

    public func measure(_ timeInterval: TimeInterval, _ request: Requestable) {
        let time = self.configuration.formatter.entry("⏰ Network Time", String(timeInterval), request)
        print(time)
    }

    public func decodingError(_ error: MTError, _ context: DecodingError.Context? = nil, _ type: Any? = nil) {
        self.configuration.output(nil, self.logDecodingError(error, context, type))
    }
}

private extension NetworkLogger {
    func logNetworkRequest(_ urlRequest: URLRequest, _ request: Requestable, completion: @escaping ([String]) -> Void) {
        var output: [String] = []

        output.append(self.configuration.formatter.entry("⬆ Request", urlRequest.description, request))

        var allHeaders: [String: String] = [:]
        if let headerFields = urlRequest.allHTTPHeaderFields {
            allHeaders.merge(headerFields) { $1 }
        }
        output.append(self.configuration.formatter.entry("⬆ Request Headers", allHeaders.description, request))

        if let bodyStreams = urlRequest.httpBodyStream {
            output.append(self.configuration.formatter.entry("⬆ Request BodyStreams", bodyStreams.description, request))
        }

        if let body = urlRequest.httpBody {
            switch request.task {
            case .uploadMultipart(let data), .uploadCompositeMultipart(let data, _):
                let body = self.multipartFormDataBody(data)
                output.append(self.configuration.formatter.entry("⬆ Request Body", body.joined(separator: "\n"), request))
            default:
                let body = self.configuration.formatter.requestData(body)
                output.append(self.configuration.formatter.entry("⬆ Request Body", body, request))
            }
        }

        if let method = urlRequest.httpMethod {
            output.append(self.configuration.formatter.entry("⬆ HTTP Request Method", method, request))
        }

        completion(output)
    }

    func logNetworkResponse(_ response: Response, _ request: Requestable) -> [String] {
        var output: [String] = []

        if let httpResponse = response.response {
            output.append(self.configuration.formatter.entry("⬇ Response", httpResponse.description, request))
        } else {
            output.append(self.configuration.formatter.entry("⬇ Response", "Received empty network response for \(request).", request))
        }

        let responseBody = response.data
        let body = self.configuration.formatter.responseData(responseBody)
        output.append(self.configuration.formatter.entry("⬇ Response Body", body, request))

        return output
    }

    func logNetworkError(_ error: MTError, _ request: Requestable) -> [String] {
        var output: [String] = []

        if let response = error.response {
            output += self.logNetworkResponse(response, request)
        } else {
            output.append(self.configuration.formatter.entry("❌ Error", "Error calling \(request) : \(error)", request))
        }

        if let description = error.errorDescription {
            output.append(self.configuration.formatter.entry("❌ Error Message", description, request))
        }

        return output
    }

    private func logDecodingError(_ error: MTError, _ context: DecodingError.Context? = nil, _ type: Any? = nil) -> [String] {
        var output: [String] = []

        if let description = error.errorDescription {
            let description = NetworkLogger.Configuration.Formatter.defaultEntryFormatter(identifier: "❌ Error Description", message: description)
            output.append(description)
        }

        if let context = context {
            var contextDescription = ""
            if let type = type {
                contextDescription += "Type \(type) mismatch" + "\n"
            }
            contextDescription += context.debugDescription + "\n" + context.codingPath.debugDescription

            let debugDescription = NetworkLogger.Configuration.Formatter.defaultEntryFormatter(identifier: "❌ Decoding Context", message: contextDescription)
            output.append(debugDescription)
        }

        return output
    }

    // MARK: - Private - MultipartFormData Body

    private func multipartFormDataBody(_ data: [MultipartFormData]) -> [String] {
        var body: [String] = []

        for datum in data {
            let convertedData = self.convertMultipartDatum(datum)
            body.append(convertedData)
        }

        return body
    }

    // MARK: - Private - Convert Multipart

    private func convertMultipartDatum(_ datum: MultipartFormData) -> String {
        switch datum.provider {
        case .data:
            return "💦 Data is still difficult to encode."
        case .parameter(let parameter):
            do {
                let data = try JSONSerialization.data(withJSONObject: parameter)
                return self.configuration.formatter.requestData(data)
            } catch {
                return "⛔️ Failed To Convert Parameter Dictionary To Data"
            }
        }
    }
}

public extension NetworkLogger {
    struct Configuration {

        public typealias OutputType = (_ request: Requestable?, _ items: [String]) -> Void

        public let formatter: Formatter
        public let output: OutputType

        public init(
            formatter: Formatter = Formatter(),
            output: @escaping OutputType = defaultOutput
        ) {
            self.formatter = formatter
            self.output = output
        }

        // MARK: - Default

        public static func defaultOutput(request: Requestable?, items: [String]) {
            for item in items {
                print(item, separator: ",", terminator: "\n")
            }
        }
    }
}

extension NetworkLogger.Configuration {
    public struct Formatter {

        public typealias DataFormatterType = (Data) -> (String)
        public typealias EntryFormatterType = (_ identifier: String, _ message: String, _ request: Requestable) -> String

        private static let divider = "==============================\n"
        private static let dateFormatString = "dd/MM/yyyy HH:mm:ss"

        public let entry: EntryFormatterType
        public let requestData: DataFormatterType
        public var responseData: DataFormatterType

        public init(
            entry: @escaping EntryFormatterType = defaultEntryFormatter,
            requestData: @escaping DataFormatterType = defaultDataFormatter,
            responseData: @escaping DataFormatterType = defaultDataFormatter
        ) {
            self.entry = entry
            self.requestData = requestData
            self.responseData = responseData
        }

        // MARK: - Defaults

        public static func defaultDataFormatter(_ data: Data) -> String {
            return String(data: data, encoding: .utf8) ?? "⛔️ String으로 Data를 인코딩할 수 없습니다."
        }

        public static func defaultEntryFormatter(identifier: String, message: String, request: Requestable? = nil) -> String {
            let date = defaultEntryDateFormatter.string(from: Date())
            return divider + "MTNetwork_Logger: [\(date)]\n\(identifier):\n\(message)"
        }

        public static var defaultEntryDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormatString
            return formatter
        }()
    }
}
