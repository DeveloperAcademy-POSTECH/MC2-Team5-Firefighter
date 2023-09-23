//
//  ChooseCharacterViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/23.
//

import Combine
import Foundation

final class ChooseCharacterViewModel: BaseViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: - property
    
    private let roomId: Int?
    
    private let participateRoomService: ParticipateRoomService
    private var cancellable = Set<AnyCancellable>()

    // MARK: - init
    
    init(participateRoomService: ParticipateRoomService, roomId: Int) {
        self.participateRoomService = participateRoomService
        self.roomId = roomId
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        return Output()
    }
    
    // MARK: - network
    
}
