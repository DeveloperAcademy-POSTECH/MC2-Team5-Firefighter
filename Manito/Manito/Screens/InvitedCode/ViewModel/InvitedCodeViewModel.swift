//
//  InvitedCodeViewModel.swift
//  Manito
//
//  Created by 이성호 on 11/4/23.
//

import Foundation

import Combine

final class InvitedCodeViewModel: BaseViewModelType {
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let copyButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let roomInfo: AnyPublisher<RoomInfo, Never>
        let copyButtonDidTap: AnyPublisher<String, Never>
    }
    
    // MARK: - property

    let roomInfo: RoomInfo
    
    // MARK: - init
    
    init(roomInfo: RoomInfo) {
        self.roomInfo = roomInfo
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        let roomInfo = input.viewDidLoad
            .compactMap { [weak self] _ in self?.roomInfo }
            .eraseToAnyPublisher()
        
        let code = input.copyButtonDidTap
            .compactMap { [weak self] in self?.roomInfo.invitation.code }
            .eraseToAnyPublisher()

        return Output(roomInfo: roomInfo,
                      copyButtonDidTap: code)
    }
}
