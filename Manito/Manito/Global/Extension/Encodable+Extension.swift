//
//  Encodable+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/12.
//

import Foundation

extension Encodable {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
