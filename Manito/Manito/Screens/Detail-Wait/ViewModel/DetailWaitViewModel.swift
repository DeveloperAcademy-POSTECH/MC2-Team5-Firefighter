//
//  DetailWaitViewModel.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/05/30.
//

import Combine

final class DetailWaitViewModel {
    
    private let roomIndex: Int
    private let detailWaitService: DetailWaitAPI
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let roomInformationDidUpdate: AnyPublisher<Room, Error>
    }
        
    let roomInformationSubject = PassthroughSubject<Room, Error>()
    
    init(roomIndex: Int, detailWaitService: DetailWaitAPI) {
        self.roomIndex = roomIndex
        self.detailWaitService = detailWaitService
    }
    
    func fetchRoomInformation() {
        Task {
            let data = try await detailWaitService.getWaitingRoomInfo(roomId: self.roomIndex.description)
            if let roomInformation = data {
                self.roomInformationSubject.send(roomInformation)
            }
        }
    }
}
