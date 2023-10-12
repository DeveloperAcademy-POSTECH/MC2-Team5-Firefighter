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
