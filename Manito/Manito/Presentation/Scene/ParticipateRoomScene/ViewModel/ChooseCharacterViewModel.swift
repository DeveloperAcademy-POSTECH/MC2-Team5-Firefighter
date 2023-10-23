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
        let joinButtonTapPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let roomId: AnyPublisher<Result<Int, ChooseCharacterError>, Never>
    }
    
    // MARK: - property
    
    private let roomId: Int
    
    private let usecase: ParticipateRoomUsecase
    private var cancellable = Set<AnyCancellable>()
    
    private let roomIdSubject = PassthroughSubject<Result<Int, ChooseCharacterError>, Never>()

    // MARK: - init
    
    init(usecase: ParticipateRoomUsecaseImpl, roomId: Int) {
        self.usecase = usecase
        self.roomId = roomId
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        input.joinButtonTapPublisher
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
                let _ = try await self.usecase.dispatchJoinRoom(roomId: roomId.description, member: MemberInfoRequestDTO(colorIndex: colorIndex))
                self.roomIdSubject.send(.success(self.roomId))
            } catch(let error) {
                guard let error = error as? ChooseCharacterError else { return }
                self.roomIdSubject.send(.failure(error))
            }
        }
    }
}
