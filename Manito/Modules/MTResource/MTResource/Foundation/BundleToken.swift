//
//  BundleToken.swift
//  MTResource
//
//  Created by SHIN YOON AH on 2023/09/11.
//

import Foundation

final class BundleToken {
    static var bundle: Bundle {
        return Bundle(for: BundleToken.self)
    }
}
