//
//  FriendListViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/19/23.
//

import Combine
import Foundation

final class FriendListViewModel: BaseViewModelType {

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    struct Output {
        let friendList: AnyPublisher<Result<FriendList, Error>, Never>
    }

    // MARK: - property
    

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: 
    private let roomId: String

    // MARK: - init

    init(usecase: MemoryUsecase,
         roomId: String) {
        self.usecase = usecase
        self.roomId = roomId
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .sink(receiveValue: { [weak self] in
                self?.fetchMemory()
            })
            .store(in: &self.cancelBag)
        
        input.segmentControlValueChanged
            .compactMap { MemberType(rawValue: $0) }
            .sink(receiveValue: { [weak self] in
                self?.sendInformation(with: $0)
            })
            .store(in: &self.cancelBag)

        return Output(
            member: self.memberSubject.eraseToAnyPublisher(),
            messages: self.messageSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private - func

    private func fetchMemory() {
        Task {
            do {
                try await self.usecase.fetchMemory(roomId: self.roomId)
                self.sendInformation(with: .manitte)
            } catch(let error) {
                self.memberSubject.send(.failure(error))
            }
        }
    }
    
    private func sendInformation(with type: MemberType) {
        guard let data = self.usecase.memory else { return }
        
        switch type {
        case .manitte:
            let memberInfo = MemberInfo(nickname: data.memoriesWithManittee.member.nickname,
                                        colorIndex: data.memoriesWithManittee.member.colorIndex)
            let message = data.memoriesWithManittee.messages.filter { $0.imageUrl != nil || $0.content != nil }
            self.memberSubject.send(.success((TextLiteral.Memory.manitteContent.localized(), memberInfo)))
            self.messageSubject.send(.success(message))
        case .manitto:
            let memberInfo = MemberInfo(nickname: data.memoriesWithManitto.member.nickname,
                                        colorIndex: data.memoriesWithManitto.member.colorIndex)
            let message = data.memoriesWithManitto.messages.filter { $0.imageUrl != nil || $0.content != nil }
            self.memberSubject.send(.success((TextLiteral.Memory.manittoContent.localized(), memberInfo)))
            self.messageSubject.send(.success(message))
        }
    }
}

