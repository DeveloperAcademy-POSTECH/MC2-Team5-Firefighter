//
//  DetailWaitViewModelTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 2023/06/06.
//

import Combine
import XCTest
@testable import Manito


final class DetailWaitViewModelTest: XCTestCase {
    
    private let viewModel = DetailWaitViewModel(roomIndex: 1, detailWaitService: DetailWaitService(api: DetailWaitAPI(apiService: APIService())))
    let testMockRoom = Room.testRoom
    private var cancellable = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        self.viewModel.setRoomInformation(room: Room.testRoom)
        self.cancellable = Set<AnyCancellable>()
    }
    
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
    
    func testInputOutput() {
        // given
        let testViewDidLoadSubject = PassthroughSubject<Void, Never>()
        let testCodeCopyButtonDidTapSubject = PassthroughSubject<Void, Never>()
        let testStartButtonDidTapSubject = PassthroughSubject<Void, Never>()
        let testEditMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
        let testDeleteMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
        let testLeaveMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
        let testChangeButtonDidTapSubject = PassthroughSubject<Void, Never>()
        
        let input = DetailWaitViewModel.Input(
            viewDidLoad: testViewDidLoadSubject.eraseToAnyPublisher(),
            codeCopyButtonDidTap: testCodeCopyButtonDidTapSubject.eraseToAnyPublisher(),
            startButtonDidTap: testStartButtonDidTapSubject.eraseToAnyPublisher(),
            editMenuButtonDidTap: testEditMenuButtonDidTapSubject.eraseToAnyPublisher(),
            deleteMenuButtonDidTap: testDeleteMenuButtonDidTapSubject.eraseToAnyPublisher(),
            leaveMenuButtonDidTap: testLeaveMenuButtonDidTapSubject.eraseToAnyPublisher(),
            changeButtonDidTap: testChangeButtonDidTapSubject.eraseToAnyPublisher())
        
        var outputCode: String = ""
        // when
        self.viewModel.setRoomInformation(room: testMockRoom)
        let output = self.viewModel.transform(input)
        testCodeCopyButtonDidTapSubject.send(())
        output.code
            .sink { code in
                outputCode = code
            }
            .store(in: &self.cancellable)
        // then
        XCTAssertEqual(outputCode, "ABCDEF")
    }
}
