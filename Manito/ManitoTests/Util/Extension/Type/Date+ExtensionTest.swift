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
        let dateString = Date().toFullString
        let today = dateString.toFullDate!
        
        // when
        let isToday = today.isToday
        
        // then
        XCTAssertTrue(isToday)
    }
    
    func test_isToday_과거날짜에_올바르게_반환하는가() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let dateString = Date().toFullString
        let today = dateString.toFullDate!
        let sut = today - oneTimeInterval
        
        // when
        let isToday = sut.isToday
        
        // then
        XCTAssertFalse(isToday)
    }
    
    func test_isToday_미래날짜에_올바르게_반환하는가() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let dateString = Date().toFullString
        let today = dateString.toFullDate!
        let sut = today + oneTimeInterval
        
        // when
        let isToday = sut.isToday
        
        // then
        XCTAssertFalse(isToday)
    }
    
    func test_isPast_변수가_존재하는가() {
        let date = Date()
        
        let _ = date.isPast
    }
    
    func test_isPast_과거날짜에_올바르게_반환하는가() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let dateString = Date().toFullString
        let today = dateString.toFullDate!
        let sut = today - oneTimeInterval
        
        // when
        let isPast = sut.isPast
        
        // then
        XCTAssertTrue(isPast)
    }
    
    func test_isPast_미래날짜에_올바르게_반환하는가() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let dateString = Date().toFullString
        let today = dateString.toFullDate!
        let sut = today + oneTimeInterval
        
        // when
        let isPast = sut.isPast
        
        // then
        XCTAssertFalse(isPast)
    }
    
    func test_isPast_오늘날짜에_올바르게_반환하는가() {
        // given
        let dateString = Date().toFullString
        let today = dateString.toFullDate!
        
        // when
        let isPast = today.isPast
        
        // then
        XCTAssertFalse(isPast)
    }
}
