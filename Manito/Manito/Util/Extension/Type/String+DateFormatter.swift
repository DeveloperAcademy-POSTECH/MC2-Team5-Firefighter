//
//  String+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

extension String {
    var toDefaultDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
    
    var toFullDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }

    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
}
