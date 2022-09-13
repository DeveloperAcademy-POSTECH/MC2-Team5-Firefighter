//
//  RoomAPI.swift
//  Manito
//
//  Created by LeeSungHo on 2022/08/31.
//

import Foundation

struct RoomAPI: RoomProtocol {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func postCreateRoom(body: CreateRoomDTO) async throws -> String? {
        let request = RoomEndPoint.dispatchCreateRoom(roomInfo: body).createRequest(environment: environment)
        return try await apiService.request(request)
    }
    
    func getVerification(body: String) async throws -> VerificationCode? {
        let request = RoomEndPoint.fetchVerifyCode(code: body).createRequest(environment: environment)
        return try await apiService.request(request)
    }
    
    func dispatchJoinRoom(roodId: String, dto: MemberDTO) async throws -> String? {
        let request = RoomEndPoint.dispatchJoinRoom(roomId: roodId, roomDto: dto).createRequest(environment: environment)
        return try await apiService.request(request)
    }
}
