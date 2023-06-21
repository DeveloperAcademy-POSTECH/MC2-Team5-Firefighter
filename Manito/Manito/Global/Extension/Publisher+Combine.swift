//
//  Publisher+Combine.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/21.
//

import Combine
import Foundation

// https://gist.github.com/pookjw/fbfba58d87563494b2fcc93077ccd4ff

extension Publisher {
    func withUnretained<T: AnyObject>(_ owner: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        return compactMap { [weak owner] output in
            owner == nil ? nil : (owner!, output)
        }
    }
}
