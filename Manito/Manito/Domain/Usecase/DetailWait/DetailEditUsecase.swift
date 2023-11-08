//
//  DetailEditUsecase.swift
//  Manito
//
//  Created by Mingwan Choi on 10/31/23.
//

import Foundation

protocol DetailEditUsecase {
    var roomInformation: RoomInfo { get set }
    
    func validStartDatePast(startDate: String) -> Bool
    func validMemberCountOver(capacity: Int) -> Bool
    func changeRoomInformation(roomDto: CreatedRoomInfoRequestDTO) async throws -> Int
}

final class DetailEditUsecaseImpl: DetailEditUsecase {
    @Published var roomInformation: RoomInfo
    
    let repository: DetailRoomRepository
    
    init(roomInformation: RoomInfo, repository: DetailRoomRepository) {
        self.roomInformation = roomInformation
        self.repository = repository
    }
    
    func validStartDatePast(startDate: String) -> Bool {
        guard let startDate = startDate.toDefaultDate else { return false }
        let isPast = startDate.isPast
        return !isPast
    }
    
    func validMemberCountOver(capacity: Int) -> Bool {
        let isUnderOverMember = self.roomInformation.participants.count <= capacity
        return isUnderOverMember
    }
    
    func changeRoomInformation(roomDto: CreatedRoomInfoRequestDTO) async throws -> Int {
        let statusCode = try await self.repository.putRoomInfo(roomId: self.roomInformation.roomInformation.id.description,
                                                               roomInfo: roomDto)
        return statusCode
    }
}
