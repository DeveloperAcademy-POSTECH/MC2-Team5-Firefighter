//
//  RoomParticipationRepository.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/08/24.
//

import Foundation

import MTNetwork

protocol RoomParticipationRepository {
    func dispatchCreateRoom(room: CreatedRoomRequestDTO) async throws -> Int
    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO
    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int
}

final class RoomParticipationRepositoryImpl: RoomParticipationRepository {

    private var provider = Provider<RoomParticipationEndPoint>()

    func dispatchCreateRoom(room: CreatedRoomRequestDTO) async throws -> Int {
        let response = try await self.provider
            .request(.dispatchCreateRoom(room: room))
        let location = response.response?.allHeaderFields["Location"] as? String
        let roomId = Int(location?.split(separator: "/").last ?? "-1") ?? -1
        return roomId
    }

    func dispatchVerifyCode(code: String) async throws -> ParticipatedRoomInfoDTO {
        let response = try await self.provider
            .request(.dispatchVerifyCode(code: code))
        return try response.decode()
    }

    func dispatchJoinRoom(roomId: String, member: MemberInfoRequestDTO) async throws -> Int {
        do {
            let response = try await self.provider
                .request(.dispatchJoinRoom(roomId: roomId,
                                           member: member))
            return response.statusCode
        } catch MTError.statusCode(reason: .clientError(let response)) {
            switch response.statusCode {
            case 409: throw ChooseCharacterError.roomAlreadyParticipating
            default: throw ChooseCharacterError.someError
            }
        }
    }
}

// FIXME: Presentation 폴더로 옮기면서 옮길 예정
enum ChooseCharacterError: LocalizedError {
    case roomAlreadyParticipating
    case someError
}
// FIXME: TextLiteral 처리는 듀나 작업 이후에 진행하겠습니다! 
extension ChooseCharacterError {
    var errorDescription: String? {
        switch self {
        case .roomAlreadyParticipating: return "이미 참여중인 방입니다."
        case .someError: return "네트워크 오류입니다."
        }
    }
}
