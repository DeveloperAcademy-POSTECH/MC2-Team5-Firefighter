//
//  RoomListItemTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 2023/09/18.
//

import Foundation
import XCTest
@testable import Manito

final class RoomListItemTest: XCTestCase {
    func test_dateRangeText_변수가_있는가() {
        let sut = RoomListItem.testRoomListItem
        
        let _ = sut.dateRangeText
    }
    
    func test_dateRangeText_변수가_올바른값을_리턴가는가() {
        // given
        let sut = RoomListItem.testRoomListItem
        
        // when
        let dateRangeText = sut.dateRangeText
        
        // then
        XCTAssertEqual(dateRangeText, "2023.01.01 ~ 2023.01.05")
    }
    
    func test_dateRangeText_변수에_틀린값이_들어왔을때_실패하는가() {
        // given
        let sut = RoomListItem.testRoomListItem
        
        // when
        let dateRangeText = sut.dateRangeText
        
        // then
        XCTAssertNotEqual(dateRangeText, "2023.01.01  ~  2023.01.05")
    }
    
    func test_isStartDatePast_변수가_있는가() {
        let sut = RoomListItem.testRoomListItem
        
        let _ = sut.isStartDatePast
    }
    
    func test_isStartDatePast_과거날짜에대해_올바르게_반환하는가() {
        // given
        let sut = RoomListItem.testRoomListItem
        
        // when
        let isPast = sut.isStartDatePast
        
        // then
        XCTAssertEqual(isPast, true)
    }
    
    func test_isStartDatePast_미래날짜에대해_올바르게_반환하는가() {
        // given
        let sut = RoomListItem(id: 0, title: "", state: "", capacity: 0, startDate: "2030.01.01", endDate: "2030.01.05")
        
        // when
        let isPast = sut.isStartDatePast
        
        // then
        XCTAssertEqual(isPast, false)
    }
    
    func test_isStartDatePast_오늘날짜에대해_올바르게_반환하는가() {
        // given
        let today = Date()
        let ondDay: TimeInterval = .oneDayInterval
        let todayAfterFiveDays = Date() + ondDay
        let todayString = today.toFullString
        let endDateString = todayAfterFiveDays.toFullString
        let sut = RoomListItem(id: 0, title: "", state: "", capacity: 0, startDate: todayString, endDate: endDateString)
        
        // when
        let isPast = sut.isStartDatePast
        
        // then
        XCTAssertEqual(isPast, false)
    }
}
