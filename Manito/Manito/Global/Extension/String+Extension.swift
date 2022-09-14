//
//  String+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

extension String {
    var stringToDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.date(from: self)
    }
    
    func subStringToDate() -> String {
        let startIdx: String.Index = self.index(self.startIndex, offsetBy: 2)
        return String(self[startIdx...])
    }
    
    func stringToDateYYYY() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.locale = Locale(identifier: "ko_KR")
        let date = formatter.date(from: self)
        return date
    }
}
