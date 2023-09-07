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
        let noButtonDidTap: AnyPublisher<Void, Never>
        let yesButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output{
        let roomInfo: AnyPublisher<ParticipatedRoomInfo, Never>
        let noButtonDidTap: AnyPublisher<Void, Never>
        let yesButtonDidTap: AnyPublisher<Int, Never>
    }
    
    func transform(from input: Input) -> Output {
        let roomInfo = input.viewDidLoad
            .map { [weak self] _ -> ParticipatedRoomInfo in
                guard let self = self else { return ParticipatedRoomInfo.emptyRoom }
                return self.roomInfo
            }
            .eraseToAnyPublisher()
        
        let noButtonDidTap = input.noButtonDidTap
            .eraseToAnyPublisher()
        
        let yesButtonDidTap = input.yesButtonDidTap
            .map { [weak self] _ -> Int in
                return self?.roomInfo.id ?? 0
            }
            .eraseToAnyPublisher()
        
        return Output(roomInfo: roomInfo,
                      noButtonDidTap: noButtonDidTap,
                      yesButtonDidTap: yesButtonDidTap)
    }
    
    // MARK: - init
    
    init(roomInfo: ParticipatedRoomInfo) {
        self.roomInfo = roomInfo
    }
    
    // MARK: - func

}
