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
        self.mockUsecase = MockDetailWaitUsecase()
    }
    
    override func tearDown() {
        self.mockUsecase = nil
    }
    
    func test_fetchRoomInformaion함수가_올바른값을_리턴하는가() async throws {
        let sut = RoomInfoDTO.testRoomDTO
        
        do {
            let roomInfoDTO = try await self.mockUsecase.fetchRoomInformaion(roomId: "")
            XCTAssertEqual(sut, roomInfoDTO)
        } catch {
            XCTFail()
        }
    }
    
    func test_patchStartManitto함수가_올바른값을_리턴하는가() async throws {
        let sut = UserInfoDTO.testUserManittee
        
        do {
            let manittee = try await self.mockUsecase.patchStartManitto(roomId: "")
            XCTAssertEqual(sut, manittee)
        } catch {
            XCTFail()
        }
    }
    
    func test_deleteRoom함수가_올바른값을_리턴하는가() async throws {
        let sut = 200
        
        do {
            let statusCode = try await self.mockUsecase.deleteRoom(roomId: "")
            XCTAssertEqual(sut, statusCode)
        } catch {
            XCTFail()
        }
    }
    
    func test_deleteLeaveRoom함수가_올바른값을_리턴하는가() async throws {
        let sut = 200
        
        do {
            let statusCode = try await self.mockUsecase.deleteLeaveRoom(roomId: "")
            XCTAssertEqual(sut, statusCode)
        } catch {
            XCTFail()
        }
    }
}

final class MockDetailWaitUsecase: DetailWaitUseCase {
    var roomInformation: Manito.RoomInfo = .testRoom
    
    func fetchRoomInformaion(roomId: String) async throws -> RoomInfoDTO {
        try await Task.sleep(nanoseconds: 3_000)
        
        return .testRoomDTO
    }
    
    func patchStartManitto(roomId: String) async throws -> UserInfoDTO {
        try await Task.sleep(nanoseconds: 3_000)
        
        return .testUserManittee
    }
    
    func deleteRoom(roomId: String) async throws -> Int {
        try await Task.sleep(nanoseconds: 3_000)
        
        return 200
    }
    
    func deleteLeaveRoom(roomId: String) async throws -> Int {
        try await Task.sleep(nanoseconds: 3_000)
        
        return 200
    }
}
