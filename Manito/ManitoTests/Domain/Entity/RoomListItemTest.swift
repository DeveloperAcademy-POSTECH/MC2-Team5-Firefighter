//
//  RoomListItemTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 2023/09/18.
//

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
}
