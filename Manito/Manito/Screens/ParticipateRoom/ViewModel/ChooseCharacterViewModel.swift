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
        let joingButtonTapPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let roomId: AnyPublisher<Int, ChooseCharacterError>
    }
    
    // MARK: - property
    
    private let roomId: Int
    
    private let roomIdSubject = PassthroughSubject<Int, ChooseCharacterError>()
    
    private let participateRoomService: ParticipateRoomService
    private var cancellable = Set<AnyCancellable>()

    // MARK: - init
    
    init(participateRoomService: ParticipateRoomService, roomId: Int) {
        self.participateRoomService = participateRoomService
        self.roomId = roomId
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        input.joingButtonTapPublisher
            .sink { [weak self] characterIndex in
                guard let self = self else { return }
                self.requestParticipateRoom(roomId: self.roomId, colorIndex: characterIndex)
            }
            .store(in: &self.cancellable)
        
        return Output(roomId: self.roomIdSubject.eraseToAnyPublisher())
    }
    
    // MARK: - network
    
    private func requestParticipateRoom(roomId: Int, colorIndex: Int) {
        Task {
            do {
                let _ = try await self.participateRoomService.dispatchJoinRoom(roomId: roomId.description, member: MemberInfoRequestDTO(colorIndex: colorIndex))
                self.roomIdSubject.send(roomId)
            } catch(let error) {
                guard let error = error as? ChooseCharacterError else { return }
                self.roomIdSubject.send(completion: .failure(error))
            }
        }
    }
}
