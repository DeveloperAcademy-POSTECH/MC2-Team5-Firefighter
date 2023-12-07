//
//  Date+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

extension Date {
    /// 해당 날짜가 오늘인지
    var isToday: Bool {
        let now = Date()
        let distance = self.distance(to: now)
        return distance > 0 && distance < .oneDayInterval
    }
    
    /// 해당 날짜가 지난날인지
    var isPast: Bool {
        let distance = self.distance(to: Date())
        return distance > .oneDayInterval
    }
    
    /// Date 값을 yy.MM.dd 형식의 String 값으로 변환
    var toDefaultString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    /// Date 값을 yyyy.MM.dd 형식의 String 값으로 변환
    var toFullString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
}
