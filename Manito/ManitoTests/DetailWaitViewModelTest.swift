//
//  DetailWaitViewModelTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 2023/06/06.
//

import XCTest
@testable import Manito


final class DetailWaitViewModelTest: XCTestCase {
    
    private let viewModel = DetailWaitViewModel(roomIndex: 1, detailWaitService: DetailWaitAPI(apiService: APIService()))
    
    func testMakeRoomInformation() {
        // given
        let testRoom = Room.testRoom
        self.viewModel.setRoomInformation(room: testRoom)
        
        // then
        let room = self.viewModel.makeRoomInformation()
        
        // when
        // FIXME: - Room 구조체 Equatable 프로토콜 채택 해야함.
        XCTAssertEqual(testRoom.roomInformation?.title, room.roomInformation?.title)
    }
}
