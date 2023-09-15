//
//  Date+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

extension Date {
    var isToday: Bool {
        let now = Date()
        let distance = self.distance(to: now)
        return distance > 0 && distance < 86400
    }

    var isPast: Bool {
        let distance = self.distance(to: Date())
        return distance > 86400
    }

    var toDefaultString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    var toFullString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }

    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
