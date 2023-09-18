//
//  String+Extension.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/09.
//

import Foundation

extension String {
    /// String 값을 yy.MM.dd 형식의 Date 값으로 변환 (옵션)
    var toDefaultDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
    
    /// String 값을 yyyy.MM.dd 형식의 Date 값으로 변환 (옵션)
    var toFullDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
}
