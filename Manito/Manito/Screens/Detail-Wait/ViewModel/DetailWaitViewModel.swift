//
//  DetailWaitViewModel.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/05/30.
//

import Combine
import Foundation

final class DetailWaitViewModel {
    
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    
    let roomInformationSubject = PassthroughSubject<Room, Error>()
    
    func fetchRoomInformation(roomIndex: Int) {
        Task {
            let data = try await detailWaitService.getWaitingRoomInfo(roomId: roomIndex.description)
            if let roomInformation = data {
                self.roomInformationSubject.send(roomInformation)
            }
        }
    }
}
