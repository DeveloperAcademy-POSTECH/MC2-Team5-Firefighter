//
//  RoomInfoTest.swift
//  ManitoTests
//
//  Created by Mingwan Choi on 2023/09/19.
//

import XCTest
@testable import Manito

final class RoomInfoTest: XCTestCase {
    func test_canStart_변수가_존재하는가() {
        let sut = RoomInfo.testRoom
        
        let _ = sut.canStart
    }
    
    func test_canStart_방장이아니고_시작인원이4명이하고_시작날짜가오늘이아닐때() {
        // given
        let sut = RoomInfo(
            roomInformation: RoomListItem(id: 0,
                                          title: "test",
                                          state: "PRE",
                                          capacity: 10,
                                          startDate: "2030.01.01",
                                          endDate: "2030.01.05"),
            participants: ParticipantList(count: 3, members: [UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee]),
            manittee: UserInfo.testUserManittee,
            manitto: UserInfo.testUserManitto,
            invitation: InvitationCode.testInvitationCode,
            didViewRoulette: false,
            mission: IndividualMission.testIndividualMission,
            admin: false,
            messages: MessageCountInfo.testMessageInfo)
        
        // when
        let canStart = sut.canStart
        
        // then
        XCTAssertFalse(canStart)
    }
    
    func test_canStart_방장이아니고_시작인원이4명이하고_시작날짜가오늘일때() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let todayString = Date().toFullString
        let endDate = todayString.toDefaultDate! + oneTimeInterval
        let endDateString = endDate.toFullString
        let sut = RoomInfo(
            roomInformation: RoomListItem(id: 0,
                                          title: "test",
                                          state: "PRE",
                                          capacity: 10,
                                          startDate: todayString,
                                          endDate: endDateString),
            participants: ParticipantList(count: 3, members: [UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee]),
            manittee: UserInfo.testUserManittee,
            manitto: UserInfo.testUserManitto,
            invitation: InvitationCode.testInvitationCode,
            didViewRoulette: false,
            mission: IndividualMission.testIndividualMission,
            admin: false,
            messages: MessageCountInfo.testMessageInfo)
        
        // when
        let canStart = sut.canStart
        
        // then
        XCTAssertFalse(canStart)
    }
    
    func test_canStart_방장이아니고_시작인원이4명이상이고_시작날짜가오늘이아닐때() {
        // given
        let sut = RoomInfo(
            roomInformation: RoomListItem(id: 0,
                                          title: "test",
                                          state: "PRE",
                                          capacity: 10,
                                          startDate: "2030.01.01",
                                          endDate: "2030.01.05"),
            participants: ParticipantList(count: 4, members: [UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee]),
            manittee: UserInfo.testUserManittee,
            manitto: UserInfo.testUserManitto,
            invitation: InvitationCode.testInvitationCode,
            didViewRoulette: false,
            mission: IndividualMission.testIndividualMission,
            admin: false,
            messages: MessageCountInfo.testMessageInfo)
        
        // when
        let canStart = sut.canStart
        
        // then
        XCTAssertFalse(canStart)
    }
    
    func test_canStart_방장이아니고_시작인원이4명이상이고_시작날짜가오늘일때() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let todayString = Date().toFullString
        let endDate = todayString.toDefaultDate! + oneTimeInterval
        let endDateString = endDate.toFullString
        let sut = RoomInfo(
            roomInformation: RoomListItem(id: 0,
                                          title: "test",
                                          state: "PRE",
                                          capacity: 10,
                                          startDate: todayString,
                                          endDate: endDateString),
            participants: ParticipantList(count: 4, members: [UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee]),
            manittee: UserInfo.testUserManittee,
            manitto: UserInfo.testUserManitto,
            invitation: InvitationCode.testInvitationCode,
            didViewRoulette: false,
            mission: IndividualMission.testIndividualMission,
            admin: false,
            messages: MessageCountInfo.testMessageInfo)
        
        // when
        let canStart = sut.canStart
        
        // then
        XCTAssertFalse(canStart)
    }
    
    func test_canStart_방장이고_시작인원이4명이하고_시작날짜가오늘이아닐때() {
        // given
        let sut = RoomInfo(
            roomInformation: RoomListItem(id: 0,
                                          title: "test",
                                          state: "PRE",
                                          capacity: 10,
                                          startDate: "2030.01.01",
                                          endDate: "2030.01.05"),
            participants: ParticipantList(count: 3, members: [UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee]),
            manittee: UserInfo.testUserManittee,
            manitto: UserInfo.testUserManitto,
            invitation: InvitationCode.testInvitationCode,
            didViewRoulette: false,
            mission: IndividualMission.testIndividualMission,
            admin: true,
            messages: MessageCountInfo.testMessageInfo)
        
        // when
        let canStart = sut.canStart
        
        // then
        XCTAssertFalse(canStart)
    }
    
    func test_canStart_방장이고_시작인원이4명이하고_시작날짜가오늘일때() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let todayString = Date().toFullString
        let endDate = todayString.toDefaultDate! + oneTimeInterval
        let endDateString = endDate.toFullString
        let sut = RoomInfo(
            roomInformation: RoomListItem(id: 0,
                                          title: "test",
                                          state: "PRE",
                                          capacity: 10,
                                          startDate: todayString,
                                          endDate: endDateString),
            participants: ParticipantList(count: 3, members: [UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee]),
            manittee: UserInfo.testUserManittee,
            manitto: UserInfo.testUserManitto,
            invitation: InvitationCode.testInvitationCode,
            didViewRoulette: false,
            mission: IndividualMission.testIndividualMission,
            admin: true,
            messages: MessageCountInfo.testMessageInfo)
        
        // when
        let canStart = sut.canStart
        
        // then
        XCTAssertFalse(canStart)
    }
    
    func test_canStart_방장이고_시작인원이4명이상이고_시작날짜가오늘이아닐때() {
        // given
        let sut = RoomInfo(
            roomInformation: RoomListItem(id: 0,
                                          title: "test",
                                          state: "PRE",
                                          capacity: 10,
                                          startDate: "2030.01.01",
                                          endDate: "2030.01.05"),
            participants: ParticipantList(count: 4, members: [UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee]),
            manittee: UserInfo.testUserManittee,
            manitto: UserInfo.testUserManitto,
            invitation: InvitationCode.testInvitationCode,
            didViewRoulette: false,
            mission: IndividualMission.testIndividualMission,
            admin: true,
            messages: MessageCountInfo.testMessageInfo)
        
        // when
        let canStart = sut.canStart
        
        // then
        XCTAssertFalse(canStart)
    }
    
    func test_canStart_방장이고_시작인원이4명이상이고_시작날짜가오늘일때() {
        // given
        let oneTimeInterval: TimeInterval = 86400
        let todayString = Date().toFullString
        let endDate = todayString.toDefaultDate! + oneTimeInterval
        let endDateString = endDate.toFullString
        let sut = RoomInfo(
            roomInformation: RoomListItem(id: 0,
                                          title: "test",
                                          state: "PRE",
                                          capacity: 10,
                                          startDate: todayString,
                                          endDate: endDateString),
            participants: ParticipantList(count: 4, members: [UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee, UserInfo.testUserManittee]),
            manittee: UserInfo.testUserManittee,
            manitto: UserInfo.testUserManitto,
            invitation: InvitationCode.testInvitationCode,
            didViewRoulette: false,
            mission: IndividualMission.testIndividualMission,
            admin: true,
            messages: MessageCountInfo.testMessageInfo)
        
        // when
        let canStart = sut.canStart
        
        // then
        XCTAssertTrue(canStart)
    }
}
