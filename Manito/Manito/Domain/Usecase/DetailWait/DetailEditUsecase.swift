//
//  DetailEditUsecase.swift
//  Manito
//
//  Created by Mingwan Choi on 10/31/23.
//

import Foundation

protocol DetailEditUsecase {
    var roomInformation: RoomInfo { get set }
    
    func changeRoomInformation(roomDto: CreatedRoomInfoRequestDTO) async throws -> Int
}

final class DetailEditUsecaseImpl: DetailEditUsecase {
    
    @Published var roomInformation: RoomInfo
    
    let repository: DetailRoomRepository
    
    init(roomInformation: RoomInfo, repository: DetailRoomRepository) {
        self.roomInformation = roomInformation
        self.repository = repository
    }
    
    func changeRoomInformation(roomDto: CreatedRoomInfoRequestDTO) async throws -> Int {
        let statusCode = try await self.repository.putRoomInfo(roomId: self.roomInformation.roomInformation.id.description,
                                                               roomInfo: roomDto)
        return statusCode
    }
}
