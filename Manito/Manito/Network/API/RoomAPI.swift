//
//  RoomAPI.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/31.
//

import Foundation

struct RoomAPI: RoomProtocol {
    private let apiService: Requestable
    
    init(apiService: Requestable) {
        self.apiService = apiService
    }
    
    func dispatchCreateRoom(body: CreateRoomDTO) async throws -> Int? {
        let request = RoomEndPoint
            .dispatchCreateRoom(roomInfo: body)
            .createRequest()
        return try await apiService.requestCreateRoom(request)
    }
    
    func dispatchVerification(body: String) async throws -> VerificationCode? {
        let request = RoomEndPoint
            .dispatchVerifyCode(code: body)
            .createRequest()
        return try await apiService.request(request)
    }
    
    func dispatchJoinRoom(roodId: String, dto: MemberDTO) async throws -> Int {
        let request = RoomEndPoint
            .dispatchJoinRoom(roomId: roodId, roomDto: dto)
            .createRequest()
        return try await apiService.request(request)
    }
}
