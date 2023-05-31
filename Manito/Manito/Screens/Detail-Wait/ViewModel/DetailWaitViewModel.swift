//
//  DetailWaitViewModel.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/05/30.
//

import Combine

final class DetailWaitViewModel {
    
    // MARK: - property
    
    private let roomIndex: Int
    private let detailWaitService: DetailWaitAPI
    @Published var roomInformation: Room?
    
    // MARK: - init
    
    init(roomIndex: Int, detailWaitService: DetailWaitAPI) {
        self.roomIndex = roomIndex
        self.detailWaitService = detailWaitService
    }
    
    // MARK: - func
    
    func fetchRoomInformation() {
        Task {
            let data = try await detailWaitService.getWaitingRoomInfo(roomId: self.roomIndex.description)
            if let roomInformation = data {
                self.roomInformation = roomInformation
            }
        }
    }
}
