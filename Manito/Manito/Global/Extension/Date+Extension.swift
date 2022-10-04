//
//  Date+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

extension Date {
    var dateToString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: self)
    }
    
    var letterDateToString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        let now = Date()
        let distance = self.distance(to: now)
        return distance > 0 && distance < 86400
    }
    
    var isOverOpenTime: Bool {
        let now = Date()
        let nineHoursTimeInterval: TimeInterval = 32400
        let dateAddNineHours = self + nineHoursTimeInterval
        let distance = dateAddNineHours.distance(to: now)
        return distance > 0 && distance < 54000
    }
    
    var isOpenManitto: Bool {
        return self.isToday && self.isOverOpenTime
    }
}
