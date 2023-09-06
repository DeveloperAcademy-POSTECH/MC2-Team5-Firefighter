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
    
    private var cancellabe = Set<AnyCancellable>()
    private let roomInfoSubject = PassthroughSubject<ParticipateRoomInfo, Never>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output{
        let roomInfo: PassthroughSubject<ParticipateRoomInfo, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad.sink { [weak self] _ in
            guard let self = self else { return }
            print("roomInfo: ", self.roomInfo )
            self.roomInfoSubject.send(self.roomInfo)
        }
        .store(in: &self.cancellabe)
        
        return Output(roomInfo: self.roomInfoSubject)
    }
    
    // MARK: - init
    
    init(roomInfo: ParticipateRoomInfo) {
        self.roomInfo = roomInfo
    }
    
    // MARK: - func

}
