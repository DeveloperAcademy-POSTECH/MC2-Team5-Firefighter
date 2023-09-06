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
    private let roomInfoSubject = PassthroughSubject<ParticipateRoomInfo, Never>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output{
        let roomInfo: PassthroughSubject<ParticipateRoomInfo, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.roomInfoSubject.send(self.roomInfo)
            }
            .store(in: &self.cancellable)
        
        return Output(roomInfo: self.roomInfoSubject)
    }
    
    // MARK: - init
    
    init(roomInfo: ParticipateRoomInfo) {
        self.roomInfo = roomInfo
    }
    
    // MARK: - func

}
