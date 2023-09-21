//
//  HTTPHeader.swift
//  
//
//  Created by SHIN YOON AH on 2023/05/18.
//

import Foundation

public struct HTTPHeaders {

    private var headers: [HTTPHeader] = []

    public init() {}

    public init(_ headers: [HTTPHeader]) {
        self.init()

        headers.forEach { self.update($0) }
    }

    ///  Case-insensitively updates or appends the provided `HTTPHeader` into the instance.
    public mutating func update(_ header: HTTPHeader) {
        guard let index = self.headers.index(of: header.name) else {
            self.headers.append(header)
            return
        }

        self.headers.replaceSubrange(index...index, with: [header])
    }

    ///  Case-insensitively removes an `HTTPHeader`, if it exists, from the instance.
    public mutating func remove(name: String) {
        guard let index = self.headers.index(of: name) else { return }

        self.headers.remove(at: index)
    }

    public var dictionary: [String: String] {
        let element = self.headers.map { ($0.name, $0.value) }

        return Dictionary(element, uniquingKeysWith: { _, last in last })
    }
}

extension Array where Element == HTTPHeader {
    ///  Case-insensitively finds the index of an `HTTPHeader` with the provided name, if it exists.
    func index(of name: String) -> Int? {
        let lowercasedName = name.lowercased()
        return firstIndex { $0.name.lowercased() == lowercasedName }
    }
}

public struct HTTPHeader {

    ///  Name of the header.
    let name: String

    ///  Value of the header.
    let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension HTTPHeader: CustomStringConvertible {
    public var description: String {
        return "\(self.name): \(self.value)"
    }
}

extension HTTPHeader {

    // MARK: - Public - Header Field

    public static func accept(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept", value: value)
    }

    public static func acceptCharset(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept-Charset", value: value)
    }

    public static func acceptLanguage(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept-Language", value: value)
    }

    public static func acceptEncoding(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Accept-Encoding", value: value)
    }

    public static func authorization(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: value)
    }

    public static func contentDisposition(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Content-Disposition", value: value)
    }

    public static func contentType(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "Content-Type", value: value)
    }

    public static func userAgent(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "User-Agent", value: value)
    }

    // MARK: - Public - Authorization

    public static func authorization(username: String, password: String) -> HTTPHeader {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()

        return self.authorization("Basic \(credential)")
    }

    public static func authorization(bearerToken: String) -> HTTPHeader {
        return self.authorization("Bearer \(bearerToken)")
    }
}
