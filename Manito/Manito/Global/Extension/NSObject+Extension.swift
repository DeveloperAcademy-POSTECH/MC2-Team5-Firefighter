//
//  NSObject+Extension.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
