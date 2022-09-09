//
//  UINotification+Extension.swift
//  Manito
//
//  Created by 이성호 on 2022/06/18.
//

import Foundation


extension Notification.Name {
    static let nextNotification = Notification.Name("NextNotification")
    static let dateRangeNotification = Notification.Name("DateRangeNotification")
    static let changeStartButtonNotification = Notification.Name("ChangeStartButtonNotification")
    static let editMaxUserNotification = Notification.Name("EditMaxUserNotification")
    static let requestDateRangeNotification = Notification.Name("RequestDateRangeNotification")
    static let requestRoomInfoNotification = Notification.Name("RequestRoomInfoNotification")
}
