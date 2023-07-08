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
    private var cancellable = Set<AnyCancellable>()
    private let testViewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let testCodeCopyButtonDidTapSubject = PassthroughSubject<Void, Never>()
    private let testStartButtonDidTapSubject = PassthroughSubject<Void, Never>()
    private let testEditMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
    private let testDeleteMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
    private let testLeaveMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
    private let testChangeButtonDidTapSubject = PassthroughSubject<Void, Never>()
    private var output: DetailWaitViewModel.Output!
    
    override func setUp() {
        super.setUp()
        self.viewModel.setRoomInformation(room: Room.testRoom)
        let input = DetailWaitViewModel.Input(
            viewDidLoad: testViewDidLoadSubject.eraseToAnyPublisher(),
            codeCopyButtonDidTap: testCodeCopyButtonDidTapSubject.eraseToAnyPublisher(),
            startButtonDidTap: testStartButtonDidTapSubject.eraseToAnyPublisher(),
            editMenuButtonDidTap: testEditMenuButtonDidTapSubject.eraseToAnyPublisher(),
            deleteMenuButtonDidTap: testDeleteMenuButtonDidTapSubject.eraseToAnyPublisher(),
            leaveMenuButtonDidTap: testLeaveMenuButtonDidTapSubject.eraseToAnyPublisher(),
            changeButtonDidTap: testChangeButtonDidTapSubject.eraseToAnyPublisher())
        self.output = self.viewModel.transform(input)
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
    
    func testTransferInvitationCode() {
        // given
        let checkCode = "ABCDEF"
        // when
        output.code
            .sink { code in
                XCTAssertEqual(code, checkCode)
            }
            .store(in: &self.cancellable)
        // then
        testCodeCopyButtonDidTapSubject.send(())
    }
}
