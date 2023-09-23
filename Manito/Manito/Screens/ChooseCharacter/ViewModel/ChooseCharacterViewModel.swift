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
        let roomId: PassthroughSubject<Int, NetworkError>
    }
    
    // MARK: - property
    
    private let roomId: Int
    
    private let roomIdSubject = PassthroughSubject<Int, NetworkError>()
    private let characterIndexSubject = CurrentValueSubject<Int, Never>(0)
    private let participateRoomService: ParticipateRoomService
    private var cancellable = Set<AnyCancellable>()

    // MARK: - init
    
    init(participateRoomService: ParticipateRoomService, roomId: Int) {
        self.participateRoomService = participateRoomService
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
                self?.requestJoinRoom(roomId: self?.roomId ?? 0, colorIndex: self?.characterIndexSubject.value ?? 0)
            }
            .store(in: &self.cancellable)
        
        return Output(roomId: self.roomIdSubject)
    }
    
    // MARK: - network
    
    private func requestJoinRoom(roomId: Int, colorIndex: Int) {
        Task {
            do {
                let statusCode = try await self.participateRoomService.dispatchJoinRoom(roomId: roomId.description, member: MemberInfoRequestDTO(colorIndex: colorIndex))
                if statusCode == 201 {
                    self.roomIdSubject.send(roomId)
                }
            } catch(let error) {
                self.roomIdSubject.send(completion: .failure(error as! NetworkError))
            }
        }
    }
}
