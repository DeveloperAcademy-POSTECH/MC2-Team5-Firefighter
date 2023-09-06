//
//  CheckRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/05.
//

import Combine
import Foundation

final class CheckRoomViewModel: ViewModelType {
    
    // MARK: - property

    private let roomInfo: ParticipateRoomInfo
    
    private var cancellable = Set<AnyCancellable>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let noButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output{
        let roomInfo: AnyPublisher<ParticipateRoomInfo, Never>
        let noButtonDidTap: AnyPublisher<Void, Never>
    }
    
    func transform(from input: Input) -> Output {
        let roomInfo = input.viewDidLoad
            .map { self.roomInfo }
            .eraseToAnyPublisher()
        
        let noButtonDidTap = input.noButtonDidTap
            .eraseToAnyPublisher()
        
        return Output(roomInfo: roomInfo,
                      noButtonDidTap: noButtonDidTap)
    }
    
    // MARK: - init
    
    init(roomInfo: ParticipateRoomInfo) {
        self.roomInfo = roomInfo
    }
    
    // MARK: - func

}
