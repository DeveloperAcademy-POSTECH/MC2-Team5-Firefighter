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
        return self.startDate + " ~ " + self.endDate
    }

    var isAlreadyPastDate: Bool {
        if let date = self.startDate.toDefaultDate {
            return date.distance(to: Date()) > 86400
        } else {
            return false
        }
    }

    var isStart: Bool {
        if let date = self.startDate.toDefaultDate {
            let isStartDate = date.distance(to: Date()) < 86400
            let isPast = date.distance(to: Date()) > 86400
            return !isPast && isStartDate
        } else {
            return false
        }
    }

    var isStartDatePast: Bool {
        guard let startDate = self.startDate.toDefaultDate else { return true }
        return startDate.isPast
    }

    var dateRange: (startDate: String, endDate: String) {
        let fiveDaysInterval: TimeInterval = 86400 * 4
        let startDate: String = self.isStartDatePast ? Date().toDefaultString : self.startDate
        let endDate: String = self.isStartDatePast ? (Date() + fiveDaysInterval).toDefaultString : self.endDate
        return (startDate, endDate)
    }
}

extension RoomListItem: Equatable {
    static let testRoomListItem = RoomListItem(
        id: 1,
        title: "테스트타이틀",
        state: "PRE",
        participatingCount: 5,
        capacity: 5,
        startDate: "2023.01.01",
        endDate: "2023.01.05"
    )
}
