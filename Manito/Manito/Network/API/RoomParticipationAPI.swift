//
//  RoomParticipationAPI.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/31.
//

import Foundation

struct RoomParticipationAPI: RoomParticipationProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func dispatchCreateRoom(roomInfo: CreateRoomDTO) async throws -> Int? {
        let request = RoomParticipationEndPoint
            .dispatchCreateRoom(roomInfo: roomInfo)
            .createRequest()
        return try await apiService.requestCreateRoom(request)
    }
    
    func dispatchVerification(code: String) async throws -> VerificationCode? {
        let request = RoomParticipationEndPoint
            .dispatchVerifyCode(code: code)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func dispatchJoinRoom(roodId: String, colorIndex: Int) async throws -> Int {
        let request = RoomParticipationEndPoint
            .dispatchJoinRoom(roomId: roodId, memberDTO: MemberDTO(colorIdx: colorIndex))
            .createRequest()
        return try await apiService.request(request)
    }
}
