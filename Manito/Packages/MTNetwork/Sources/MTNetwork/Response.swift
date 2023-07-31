//
//  Response.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/17.
//

import Foundation

public struct Response {

    ///  The status code of the response.
    public let statusCode: Int

    ///  The HTTPURLResponse object.
    public let response: HTTPURLResponse?

    ///  The response data.
    public let data: Data

    ///  A text description of the `Response`.
    public var description: String {
        return "Status Code: \(self.statusCode), Data Length: \(self.data.count)"
    }

}

public extension Response {
    ///  Decode the data in Response to the desired type
    func decode<T: Decodable>() throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            let response = try decoder.decode(T.self, from: self.data)
            return response
        } catch DecodingError.dataCorrupted(let context) {
            throw self.error(context)
        } catch DecodingError.keyNotFound(_, let context) {
            throw self.error(context)
        } catch DecodingError.typeMismatch(let type, let context) {
            throw self.error(context, type)
        } catch DecodingError.valueNotFound(let type, let context) {
            throw self.error(context, type)
        } catch {
            throw self.error()
        }
    }
}

extension Response {

    // MARK: - Private - Logger

    private func error(_ context: DecodingError.Context? = nil, _ type: Any? = nil) -> Error {
        let mtError = MTError.responseDecodingFailed(self)
        NetworkLogger().decodingError(mtError, context, type)
        return mtError
    }
}
