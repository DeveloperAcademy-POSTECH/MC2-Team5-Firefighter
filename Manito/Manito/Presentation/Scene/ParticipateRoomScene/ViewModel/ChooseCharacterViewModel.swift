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
        let joinButtonTapPublisher: AnyPublisher<Void, Never>
        let characterIndexPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let roomId: PassthroughSubject<Int, ChooseCharacterError>
    }
    
    // MARK: - property
    
    private let roomId: Int
    
    private let roomIdSubject = PassthroughSubject<Int, ChooseCharacterError>()
    private let characterIndexSubject = CurrentValueSubject<Int, Never>(0)
    
    private let usecase: ParticipateRoomUsecaseImpl
    private var cancellable = Set<AnyCancellable>()

    // MARK: - init
    
    init(usecase: ParticipateRoomUsecaseImpl, roomId: Int) {
        self.usecase = usecase
        self.roomId = roomId
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        input.characterIndexPublisher
            .sink { [weak self] index in
                self?.characterIndexSubject.send(index)
            }
            .store(in: &self.cancellable)
        
        input.joinButtonTapPublisher
            .sink { [weak self] _ in
                self?.requestParticipateRoom(roomId: self!.roomId, colorIndex: self?.characterIndexSubject.value ?? 0)
            }
            .store(in: &self.cancellable)
        
        return Output(roomId: self.roomIdSubject)
    }
    
    // MARK: - network
    
    private func requestParticipateRoom(roomId: Int, colorIndex: Int) {
        Task {
            do {
                let _ = try await self.usecase.dispatchJoinRoom(roomId: roomId.description, member: MemberInfoRequestDTO(colorIndex: colorIndex))
                self.roomIdSubject.send(roomId)
            } catch(let error) {
                guard let error = error as? ChooseCharacterError else { return }
                self.roomIdSubject.send(completion: .failure(error))
            }
        }
    }
}