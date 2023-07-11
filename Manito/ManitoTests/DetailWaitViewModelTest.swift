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
    private var viewModel: DetailWaitViewModel!
    private var service: MockDetailWaitService!
    private var cancellable: Set<AnyCancellable>!
    private var testViewDidLoadSubject: PassthroughSubject<Void, Never>!
    private var testCodeCopyButtonDidTapSubject: PassthroughSubject<Void, Never>!
    private var testStartButtonDidTapSubject: PassthroughSubject<Void, Never>!
    private var testEditMenuButtonDidTapSubject: PassthroughSubject<Void, Never>!
    private var testDeleteMenuButtonDidTapSubject: PassthroughSubject<Void, Never>!
    private var testLeaveMenuButtonDidTapSubject: PassthroughSubject<Void, Never>!
    private var testChangeButtonDidTapSubject: PassthroughSubject<Void, Never>!
    private var output: DetailWaitViewModel.Output!
    
    override func setUp() {
        super.setUp()
        self.service = MockDetailWaitService()
        self.viewModel = DetailWaitViewModel(roomIndex: 0, detailWaitService: self.service)
        self.cancellable = Set<AnyCancellable>()
        self.testViewDidLoadSubject = PassthroughSubject<Void, Never>()
        self.testCodeCopyButtonDidTapSubject = PassthroughSubject<Void, Never>()
        self.testStartButtonDidTapSubject = PassthroughSubject<Void, Never>()
        self.testEditMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
        self.testDeleteMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
        self.testLeaveMenuButtonDidTapSubject = PassthroughSubject<Void, Never>()
        self.testChangeButtonDidTapSubject = PassthroughSubject<Void, Never>()
        let input = DetailWaitViewModel.Input(
            viewDidLoad: testViewDidLoadSubject.eraseToAnyPublisher(),
            codeCopyButtonDidTap: testCodeCopyButtonDidTapSubject.eraseToAnyPublisher(),
            startButtonDidTap: testStartButtonDidTapSubject.eraseToAnyPublisher(),
            editMenuButtonDidTap: testEditMenuButtonDidTapSubject.eraseToAnyPublisher(),
            deleteMenuButtonDidTap: testDeleteMenuButtonDidTapSubject.eraseToAnyPublisher(),
            leaveMenuButtonDidTap: testLeaveMenuButtonDidTapSubject.eraseToAnyPublisher(),
            changeButtonDidTap: testChangeButtonDidTapSubject.eraseToAnyPublisher())
        self.output = self.viewModel.transform(input)
        self.viewModel.setRoomInformation(room: Room.testRoom)
    }
    
    override func tearDown() {
        super.tearDown()
        self.viewModel = nil
        self.cancellable = nil
        self.testViewDidLoadSubject = nil
        self.testCodeCopyButtonDidTapSubject = nil
        self.testStartButtonDidTapSubject = nil
        self.testEditMenuButtonDidTapSubject = nil
        self.testDeleteMenuButtonDidTapSubject = nil
        self.testLeaveMenuButtonDidTapSubject = nil
        self.testChangeButtonDidTapSubject = nil
    }
    
    func testMakeRoomInformation() {
        // given
        let checkRoom = Room.testRoom
        self.viewModel.setRoomInformation(room: checkRoom)
        
        // then
        let testRoom = self.viewModel.makeRoomInformation()
        
        // when
        XCTAssertEqual(checkRoom, testRoom)
    }
    
    func testTransferInvitationCode() {
        // given
        let checkCode = "ABCDEF"
        var testCode = ""
        
        // when
        self.output.code
            .sink { code in
                testCode = code
            }
            .store(in: &self.cancellable)
        self.testCodeCopyButtonDidTapSubject.send(())
        
        // then
        XCTAssertEqual(checkCode, testCode)
    }
    
    func testTransferRoomInformation() {
        // given
        let checkRoom = mockRoom
        let expectation = XCTestExpectation(description: "roomInformation test")
        var testRoom = Room.emptyRoom
        
        // when
        self.output.roomInformation
            .sink(receiveCompletion: { result in
                switch result {
                case .failure:
                    break
                case .finished:
                    break
                }
            }, receiveValue: { room in
                testRoom = room
                expectation.fulfill()
            })
            .store(in: &self.cancellable)
        self.testViewDidLoadSubject.send(())
        
        // then
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(checkRoom, testRoom)
    }
    
    func testTranferStartButton() {
        // given
        let checkNickname = "테스트마니띠"
        let expectation = XCTestExpectation(description: "startButton test")
        var testNickname = ""
        
        // when
        self.output.manitteeNickname
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    XCTFail("fail")
                }
            }, receiveValue: { nickname in
                testNickname = nickname
                expectation.fulfill()
            })
            .store(in: &self.cancellable)
        self.testStartButtonDidTapSubject.send(())
        
        // then
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(checkNickname, testNickname)
    }
    
    func testTransferEditRoom() {
        // given
        let checkRoom = Room.testRoom
        let checkMode: DetailEditView.EditMode = .information
        let expectation = XCTestExpectation(description: "editButton test")
        var testRoom = Room.emptyRoom
        var testMode: DetailEditView.EditMode = .date
        
        // when
        self.output.editRoomInformation
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    XCTFail("fail")
                }
            }, receiveValue: { (room, mode) in
                testRoom = room
                testMode = mode
                expectation.fulfill()
            })
            .store(in: &self.cancellable)
        self.testEditMenuButtonDidTapSubject.send(())
        
        // then
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(checkRoom, testRoom)
        XCTAssertEqual(checkMode, testMode)
    }
    
    func testTransferDeleteRoom() {
        // given
        let expectation = XCTestExpectation(description: "deleteButton test")
        var testBool = false
        
        // when
        self.output.deleteRoom
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    XCTFail("fail")
                }
            }, receiveValue: { _ in
                testBool = true
                expectation.fulfill()
            })
            .store(in: &self.cancellable)
        self.testDeleteMenuButtonDidTapSubject.send(())
        
        // then
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(testBool)
    }
    
    func testTransferLeaveRoom() {
        // given
        let expectation = XCTestExpectation(description: "leaveButton test")
        var testBool = false
        
        // when
        self.output.leaveRoom
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    XCTFail("fail")
                }
            }, receiveValue: { _ in
                testBool = true
                expectation.fulfill()
            })
            .store(in: &self.cancellable)
        self.testLeaveMenuButtonDidTapSubject.send(())
        
        // then
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(testBool)
    }
    
    func testTransferChnageButtonDidTap() {
        // given
        let checkRoom = mockRoom
        let expectation = XCTestExpectation(description: "changeButton test")
        var testRoom = Room.emptyRoom
        
        // when
        self.testChangeButtonDidTapSubject.send(())
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testRoom = self.viewModel.makeRoomInformation()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(checkRoom, testRoom)
    }
    
    func testTransferViewDidLoad() {
        // given
        let checkRoom = mockRoom
        let expectation = XCTestExpectation(description: "viewDidLoad test")
        var testRoom = Room.emptyRoom
        
        // when
        self.testViewDidLoadSubject.send()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testRoom = self.viewModel.makeRoomInformation()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(checkRoom, testRoom)
    }
}

extension DetailWaitViewModelTest {
    var mockRoom: Room {
        return Room(roomInformation: RoomInfo(id: 10, capacity: 10, title: "목타이틀", startDate: "", endDate: "", state: ""),
                             participants: Participants.testParticipants,
                             manittee: Manittee.testManittee,
                             manitto: Manitto.testManitto,
                             invitation: Invitation.testInvitation,
                             mission: Mission.testMission,
                             admin: true,
                             messages: Message1.testMessage)
    }
}

final class MockDetailWaitService: DetailWaitServicable {
    // FIXME: - network mocking 만들어야함.
    func fetchWaitingRoomInfo(roomId: String) async throws -> Manito.Room {
        let room = Room(roomInformation: RoomInfo(id: 10, capacity: 10, title: "목타이틀", startDate: "", endDate: "", state: ""),
                        participants: Participants.testParticipants,
                        manittee: Manittee.testManittee,
                        manitto: Manitto.testManitto,
                        invitation: Invitation.testInvitation,
                        mission: Mission.testMission,
                        admin: true,
                        messages: Message1.testMessage)
        return room
    }
    
    func patchStartManitto(roomId: String) async throws -> Manito.Manittee {
        return Manittee.testManittee
    }
    
    func deleteRoom(roomId: String) async throws -> Int {
        return 200
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> Int {
        return 200
    }
}
