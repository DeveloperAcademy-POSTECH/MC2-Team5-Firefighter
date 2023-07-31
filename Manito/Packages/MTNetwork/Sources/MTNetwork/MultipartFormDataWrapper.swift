//
//  MultipartFormDataWrapper.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/18.
//

import Foundation

open class MultipartFormDataWrapper {

    private enum EncodingCharacters {
        static let crlf = "\r\n"
    }

    private enum BoundaryGenerator {
        enum BoundaryType {
            case inital, encapsulated, final
        }

        static func randomBoundary() -> String {
            let first = UInt32.random(in: UInt32.min...UInt32.max)
            let second = UInt32.random(in: UInt32.min...UInt32.max)

            return String(format: "mtnetwork.boundary.%08x%08x", first, second)
        }

        static func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
            let boundaryText: String

            switch boundaryType {
            case .inital:
                boundaryText = "--\(boundary)\(EncodingCharacters.crlf)"
            case .encapsulated:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)\(EncodingCharacters.crlf)"
            case .final:
                boundaryText = "\(EncodingCharacters.crlf)--\(boundary)--\(EncodingCharacters.crlf)"
            }

            return Data(boundaryText.utf8)
        }
    }

    lazy var contentType: String = "multipart/form-data; boundary=\(self.boundary)"

    let boundary: String
    var bodyPart: [MultipartFormData]

    init(data: [MultipartFormData], boundary: String? = nil) {
        self.boundary = boundary ?? BoundaryGenerator.randomBoundary()
        self.bodyPart = data
    }
}

extension MultipartFormDataWrapper {
    func encode() throws -> Data {
        var encoded = Data()

        let data = try self.applyMultipartFormData()
        encoded.append(data)

        let finalData = self.finalBoundaryData()
        encoded.append(finalData)

        return encoded
    }
}

extension MultipartFormDataWrapper {

    // MARK: - Private - Handle MultipartFormData Provider

    private func applyMultipartFormData() throws -> Data {
        var encoded = Data()

        if !self.bodyPart.isEmpty {
            self.bodyPart[0].hasInitialBoundary = true
        } else {
            throw MTError.multipartEncodingFailed(reason: .invalidData)
        }

        for body in self.bodyPart {
            switch body.provider {
            case .data(let data):
                let data = self.append(data: data,
                                       name: body.name,
                                       filename: body.filename,
                                       mimeType: body.mimeType,
                                       hasInitialBoundary: body.hasInitialBoundary)
                encoded.append(data)
            case .parameter(let parameters):
                let data = self.append(parameters: parameters,
                                       hasInitialBoundary: body.hasInitialBoundary)
                encoded.append(data)
            }
        }

        return encoded
    }

    // MARK: - Private - Append Data

    private func append(data: Data,
                        name: String,
                        filename: String? = nil,
                        mimeType: String? = nil,
                        hasInitialBoundary: Bool = false) -> Data {
        var encoded = Data()

        let initialData = hasInitialBoundary ? self.initialBoundaryData() : self.encapsulatedBoundaryData()
        encoded.append(initialData)

        let contentHeader = self.contentHeaders(withName: name, filename: filename, mimeType: mimeType)
        encoded.append(contentHeader)

        encoded.append(data)

        return encoded
    }

    private func append(parameters: [String: Any], hasInitialBoundary: Bool = false) -> Data {
        var encoded = Data()

        let initialData = hasInitialBoundary ? self.initialBoundaryData() : self.encapsulatedBoundaryData()
        encoded.append(initialData)

        for (index, (key, value)) in parameters.enumerated() {
            if !index.isZero {
                let encapsulatedData = self.encapsulatedBoundaryData()
                encoded.append(encapsulatedData)
            }

            let contentHeader = self.parameterHeaders(withName: key)
            encoded.append(contentHeader)

            encoded.append("\(value)")
        }

        return encoded
    }

    // MARK: - Private - Boundary Encoding

    private func initialBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(forBoundaryType: .inital, boundary: self.boundary)
    }

    private func encapsulatedBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(forBoundaryType: .encapsulated, boundary: self.boundary)
    }

    private func finalBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(forBoundaryType: .final, boundary: self.boundary)
    }

    // MARK: - Private - Content Headers

    private func contentHeaders(withName name: String, filename: String? = nil, mimeType: String? = nil) -> Data {
        var encoded = Data()

        var disposition = "form-data; name=\"\(name)\""
        if let fileName = filename, let mimeType = mimeType {
            if let type = mimeType.split(separator: "/").last.map({ String($0) }) {
                disposition += "; filename=\"\(fileName).\(type)\""
            } else {
                disposition += "; filename=\"\(fileName)\""
            }
        }
        encoded.append("Content-Disposition: \(disposition)\(EncodingCharacters.crlf)")

        if let mimeType = mimeType {
            encoded.append("Content-Type: \(mimeType)\(EncodingCharacters.crlf)\(EncodingCharacters.crlf)")
        }

        return encoded
    }

    private func parameterHeaders(withName name: String) -> Data {
        var encoded = Data()

        let disposition = "form-data; name=\"\(name)\""
        encoded.append("Content-Disposition: \(disposition)\(EncodingCharacters.crlf)\(EncodingCharacters.crlf)")

        return encoded
    }
}

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

fileprivate extension Int {
    var isZero: Bool {
        return self == 0
    }
}
