//
//  ParticipationRoomDetailsViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/05.
//

import Combine
import Foundation

final class ParticipationRoomDetailsViewModel: BaseViewModelType {
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let yesButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let roomInfo: AnyPublisher<ParticipatedRoomInfo, Never>
        let yesButtonDidTap: AnyPublisher<Int, Never>
    }
    
    // MARK: - property

    private let roomInfo: ParticipatedRoomInfo
    private var cancellable: Set<AnyCancellable> = Set()
    
    // MARK: - init
    
    init(roomInfo: ParticipatedRoomInfo) {
        self.roomInfo = roomInfo
    }
    
    // MARK: - func

    func transform(from input: Input) -> Output {
        let roomInfo = input.viewDidLoad
            .compactMap { [weak self] in self?.roomInfo }
            .eraseToAnyPublisher()
        
        let yesButtonDidTap = input.yesButtonDidTap
            .compactMap { [weak self] in self?.roomInfo.id }
            .eraseToAnyPublisher()
        
        return Output(roomInfo: roomInfo,
                      yesButtonDidTap: yesButtonDidTap)
    }
}
