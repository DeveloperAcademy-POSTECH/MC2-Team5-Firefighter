//
//  RoomListItem.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

struct RoomListItem {
    let id: Int
    let title: String
    let state: RoomStatus
    let participatingCount: Int?
    let capacity: Int
    let startDate: String
    let endDate: String

    init(
        id: Int,
        title: String,
        state: String,
        participatingCount: Int? = nil,
        capacity: Int,
        startDate: String,
        endDate: String
    ) {
        self.id = id
        self.title = title
        self.participatingCount = participatingCount
        self.capacity = capacity
        self.startDate = startDate
        self.endDate = endDate
        self.state = RoomStatus(rawValue: state) ?? .PRE
    }
}

extension RoomListItem {
    var dateRangeText: String {
        return startDate + " ~ " + endDate
    }

    var isAlreadyPastDate: Bool {
        if let date = startDate.stringToDate {
            return date.distance(to: Date()) > 86400
        } else {
            return false
        }
    }

    var isStart: Bool {
        if let date = startDate.stringToDate {
            let isStartDate = date.distance(to: Date()) < 86400
            let isPast = date.distance(to: Date()) > 86400
            return !isPast && isStartDate
        } else {
            return false
        }
    }

    var isStartDatePast: Bool {
        guard let startDate = self.startDate.stringToDate else { return true }
        return startDate.isPast
    }

    var dateRange: (startDate: String, endDate: String) {
        let fiveDaysInterval: TimeInterval = 86400 * 4
        let startDate: String = isStartDatePast ? Date().dateToString : self.startDate
        let endDate: String = isStartDatePast ? (Date() + fiveDaysInterval).dateToString : self.endDate

        return (startDate, endDate)
    }
}
