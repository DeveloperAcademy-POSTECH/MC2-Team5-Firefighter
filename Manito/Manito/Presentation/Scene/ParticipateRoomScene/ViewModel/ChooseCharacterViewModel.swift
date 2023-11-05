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
    private var cancellable: Set<AnyCancellable> = Set()

    // MARK: - init
    
    init(usecase: ParticipateRoomUsecase, roomId: Int) {
        self.usecase = usecase
        self.roomId = roomId
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        let roomId = input.joinButtonTapPublisher
            .asyncMap { [weak self] characterIndex -> Result<Int, ChooseCharacterError> in
                do {
                    let roomId = try await self?.dispatchJoinRoom(roomId: self?.roomId ?? 0, colorIndex: characterIndex)
                    return .success(roomId ?? 0)
                } catch (let error) {
                    guard let error = error as? ChooseCharacterError else { return .failure(.unknownError) }
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()
        
        return Output(roomId: roomId)
    }
}

// MARK: - Helper

extension ChooseCharacterViewModel {
    private func dispatchJoinRoom(roomId: Int, colorIndex: Int) async throws -> Int {
        return try await self.usecase.dispatchJoinRoom(roomId: roomId.description, member: MemberInfoRequestDTO(colorIndex: colorIndex))
    }
}

