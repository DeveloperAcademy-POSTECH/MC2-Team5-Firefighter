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

    private let roomInfo: ParticipatedRoomInfo
    private var cancellable = Set<AnyCancellable>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let yesButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output{
        let roomInfo: AnyPublisher<ParticipatedRoomInfo, Never>
        let yesButtonDidTap: AnyPublisher<Int, Never>
    }
    
    func transform(from input: Input) -> Output {
        let roomInfo = input.viewDidLoad
            .compactMap { [weak self] _ -> ParticipatedRoomInfo? in
                return self?.roomInfo
            }
            .eraseToAnyPublisher()
        
        let yesButtonDidTap = input.yesButtonDidTap
            .compactMap { [weak self] _  -> Int? in
                return self?.roomInfo.id
            }
            .eraseToAnyPublisher()
        
        return Output(roomInfo: roomInfo,
                      yesButtonDidTap: yesButtonDidTap)
    }
    
    // MARK: - init
    
    init(roomInfo: ParticipatedRoomInfo) {
        self.roomInfo = roomInfo
    }
    
    // MARK: - func

}
