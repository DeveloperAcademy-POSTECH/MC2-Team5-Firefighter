//
//  DetailWaitUsecaseTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 10/12/23.
//

import XCTest
@testable import Manito

final class DetailWaitUsecaseTest: XCTestCase {
    private var mockUsecase: DetailWaitUseCase!
    
    override func setUp() {
        self.mockUsecase = MockDetailWaitUsecase(statusCode: 204)
    }
    
    override func tearDown() {
        self.mockUsecase = nil
    }
    
    func test_fetchRoomInformaion함수가_올바른값을_리턴하는가() async throws {
        let sut = RoomInfoDTO.testDummyRoomDTO
        
        do {
            let roomInfoDTO = try await self.mockUsecase.fetchRoomInformaion(roomId: "")
            XCTAssertEqual(sut, roomInfoDTO)
        } catch {
            XCTFail()
        }
    }
    
    func test_patchStartManitto함수가_올바른값을_리턴하는가() async throws {
        let sut = UserInfoDTO.testDummyUserManittee
        
        do {
            let manittee = try await self.mockUsecase.patchStartManitto(roomId: "")
            XCTAssertEqual(sut, manittee)
        } catch {
            XCTFail()
        }
    }
    
    func test_deleteRoom함수가_올바른값을_리턴하는가() async throws {
        do {
            let statusCode = try await self.mockUsecase.deleteRoom(roomId: "")
            if statusCode == 204 {
                XCTAssertTrue(true)
            } else {
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
    
    func test_deleteLeaveRoom함수가_올바른값을_리턴하는가() async throws {
        do {
            let statusCode = try await self.mockUsecase.deleteLeaveRoom(roomId: "")
            if statusCode == 204 {
                XCTAssertTrue(true)
            } else {
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
    
    func test_delete함수가_400이들어왔을때_에러를_리턴하는가() async throws {
        let mock = MockDetailWaitUsecase(statusCode: 400)
        
        do {
            let statusCode = try await mock.deleteRoom(roomId: "")
            if statusCode == 204 {
                XCTFail()
            } else {
                XCTAssertTrue(true)
            }
        } catch {
            XCTAssertTrue(true)
        }
    }
}

final class MockDetailWaitUsecase: DetailWaitUseCase {
    let statusCode: Int
    var roomInformation: Manito.RoomInfo = .testRoom
    
    init(statusCode: Int) {
        self.statusCode = statusCode
    }
    
    func fetchRoomInformaion(roomId: String) async throws -> RoomInfoDTO {
        try await Task.sleep(nanoseconds: 3_000)
        
        return .testDummyRoomDTO
    }
    
    func patchStartManitto(roomId: String) async throws -> UserInfoDTO {
        try await Task.sleep(nanoseconds: 3_000)
        
        return .testDummyUserManittee
    }
    
    func deleteRoom(roomId: String) async throws -> Int {
        try await Task.sleep(nanoseconds: 3_000)
        
        return self.statusCode
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> Int {
        try await Task.sleep(nanoseconds: 3_000)
        
        return self.statusCode
    }
}
