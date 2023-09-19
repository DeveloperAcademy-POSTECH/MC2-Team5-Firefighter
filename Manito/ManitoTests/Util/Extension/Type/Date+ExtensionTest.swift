//
//  Date+ExtensionTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 2023/09/19.
//

import XCTest
@testable import Manito

final class Date_ExtensionTest: XCTestCase {
    func test_isToday_변수가_존재하는가() {
        let sut = Date()
        
        let _ = sut.isToday
    }
    
    func test_isToday_오늘날짜에_올바르게_반환하는가() {
        // given
        let date = Date().toFullString
        let today = date.toFullDate!
        
        // when
        let isToday = today.isToday
        
        // then
        XCTAssertTrue(isToday)
    }
    
    func test_isToday_과거날짜에_올바르게_반환하는가() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let date = Date().toFullString
        let today = date.toFullDate!
        let sut = today - oneTimeInterval
        
        // when
        let isToday = sut.isToday
        
        // then
        XCTAssertFalse(isToday)
    }
    
    func test_isToday_미래날짜에_올바르게_반환하는가() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let date = Date().toFullString
        let today = date.toFullDate!
        let sut = today + oneTimeInterval
        
        // when
        let isToday = sut.isToday
        
        // then
        XCTAssertFalse(isToday)
    }
}
