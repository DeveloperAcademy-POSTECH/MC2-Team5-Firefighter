//
//  Int+RandomNumber.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import Foundation

extension Int {
    static func random(in range: ClosedRange<Int>, excluding overlapNumber: Int) -> Int {
        if range.contains(overlapNumber) {
            let randomNumber = Int.random(in: Range(uncheckedBounds: (range.lowerBound, range.upperBound)))
            return randomNumber == overlapNumber ? range.upperBound : randomNumber
        } else {
            return Int.random(in: range)
        }
    }
}
