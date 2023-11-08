//
//  DetailEditUsecaseTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 11/8/23.
//

import XCTest
@testable import Manito

final class DetailEditUsecaseTest: XCTestCase {
    private var mockUsecase: DetailEditUsecase!
    
    override func setUp() {
        self.mockUsecase = MockDetailEditUsecase(roomInformation: .testRoom)
    }
    
    override func tearDown() {
        self.mockUsecase = nil
    }
    
    func test_validStartDatePast함수에_올바른_날짜형식의_텍스트에_반응하는가() {
        // given
        let date = "aaaa.aa.aa"
        // when
        let sut = self.mockUsecase.validStartDatePast(startDate: date)
        // then
        XCTAssertFalse(sut)
    }
    
    func test_validStartDatePast함수에_과거날짜가_들어갔을때() {
        // given
        let date = "2000.01.01"
        // when
        let sut = self.mockUsecase.validStartDatePast(startDate: date)
        // then
        XCTAssertFalse(sut)
    }
    
    func test_validStartDatePast함수에_오늘날짜가_들어갔을때() {
        // given
        let today = Date().toFullString
        // when
        let sut = self.mockUsecase.validStartDatePast(startDate: today)
        // then
        XCTAssertTrue(sut)
    }
    
    func test_validStartDatePast함수에_내일날짜가_들어갔을때() {
        // given
        let oneDay: TimeInterval = 86400
        let tomorrow = (Date() + oneDay).toFullString
        // when
        let sut = self.mockUsecase.validStartDatePast(startDate: tomorrow)
        // then
        XCTAssertTrue(sut)
    }
    
    func test_validStartDatePast함수에_먼미래날짜가_들어갔을때() {
        // given
        let date = "2050.01.01"
        // when
        let sut = self.mockUsecase.validStartDatePast(startDate: date)
        // then
        XCTAssertTrue(sut)
    }
    
    func test_validMemberCountOver함수에_5명이참여중인데_4명으로_수정했을때() {
        // given
        let capacity = 4
        // when
        let sut = self.mockUsecase.validMemberCountOver(capacity: capacity)
        // then
        XCTAssertFalse(sut)
    }
    
    func test_validMemberCountOver함수에_5명이참여중인데_5명으로_수정했을때() {
        // given
        let capacity = 5
        // when
        let sut = self.mockUsecase.validMemberCountOver(capacity: capacity)
        // then
        XCTAssertTrue(sut)
    }
    
    func test_validMemberCountOver함수에_5명이참여중인데_10명으로_수정했을때() {
        // given
        let capacity = 10
        // when
        let sut = self.mockUsecase.validMemberCountOver(capacity: capacity)
        // then
        XCTAssertTrue(sut)
    }
    
    func test_changeRoomInformation() async throws {
        let dto: CreatedRoomInfoRequestDTO = .init(title: "테스트",
                                                   capacity: 5,
                                                   startDate: "2025.01.01",
                                                   endDate: "2025.01.05")
        
        do {
            let statusCode = try await self.mockUsecase.changeRoomInformation(roomDto: dto)
            if statusCode == 204 {
                XCTAssertTrue(true)
            } else {
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
}

final class MockDetailEditUsecase: DetailEditUsecase {
    private let usecaseImpl: DetailEditUsecase = DetailEditUsecaseImpl(roomInformation: .testRoom,
                                                                       repository: DetailRoomRepositoryImpl())
    var roomInformation: Manito.RoomInfo
    
    init(roomInformation: Manito.RoomInfo) {
        self.roomInformation = roomInformation
    }
    
    func validStartDatePast(startDate: String) -> Bool {
        let value = self.usecaseImpl.validStartDatePast(startDate: startDate)
        return value
    }
    
    func validMemberCountOver(capacity: Int) -> Bool {
        let value = self.usecaseImpl.validMemberCountOver(capacity: capacity)
        return value
    }
    
    func changeRoomInformation(roomDto: Manito.CreatedRoomInfoRequestDTO) async throws -> Int {
        try await Task.sleep(nanoseconds: 3_000)
        
        return 204
    }
}
