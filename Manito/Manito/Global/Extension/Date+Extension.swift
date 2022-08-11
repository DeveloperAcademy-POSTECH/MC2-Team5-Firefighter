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
}
