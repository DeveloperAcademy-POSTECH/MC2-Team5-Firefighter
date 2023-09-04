//
//  ParticipateRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/04.
//

import Combine
import Foundation

final class ParticipateRoomViewModel: ViewModelType {
    
    // MARK: - property
    
    private let participateRoomService: ParticipateRoomService
    private var cancellable = Set<AnyCancellable>()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input) -> Output {
        return Output()
    }
    
    // MARK: - init
    
    init(participateRoomService: ParticipateRoomService) {
        self.participateRoomService = participateRoomService
    }
    
    // MARK: - func
    
    // MARK: - network
    
}
