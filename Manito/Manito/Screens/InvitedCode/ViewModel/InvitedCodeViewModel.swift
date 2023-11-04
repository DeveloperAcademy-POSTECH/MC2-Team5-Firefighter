//
//  InvitedCodeViewModel.swift
//  Manito
//
//  Created by 이성호 on 11/4/23.
//

import Foundation

import Combine

final class InvitedCodeViewModel: BaseViewModelType {
    
    typealias RoomInfo = (roomInfo: RoomListItem, code: String)
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let roomInfo: AnyPublisher<RoomInfo, Never>
    }
    
    // MARK: - property
    
    let roomInfo: RoomListItem
    let code: String
    
    // MARK: - init
    
    init(roomInfo: RoomListItem, code: String) {
        self.roomInfo = roomInfo
        self.code = code
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        let roomInfo = input.viewDidLoad
            .map { [weak self] _ in
                return RoomInfo(roomInfo: self?.roomInfo ?? RoomListItem.emptyRoomListItem, code: self?.code ?? "")
            }
            .eraseToAnyPublisher()
            
        return Output(roomInfo: roomInfo)
    }
}
