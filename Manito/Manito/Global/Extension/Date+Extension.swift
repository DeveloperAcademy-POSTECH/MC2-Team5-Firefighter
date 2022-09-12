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
    
    func isToday() -> Bool {
        let now = Date()
        let distance = self.distance(to: now)
        return distance > 0 && distance < 86400
    }
    
    func isOverOpenTime() -> Bool {
        let now = Date()
        let nineHoursTimeInterval: TimeInterval = 32400
        let dateAddNineHours = self + nineHoursTimeInterval
        let distance = dateAddNineHours.distance(to: now)
        return distance > 0 && distance < 54000
    }
    
    func isOpenManitto() -> Bool {
        if self.isToday() && self.isOverOpenTime() {
            return true
        } else {
            return false
        }
    }
}
