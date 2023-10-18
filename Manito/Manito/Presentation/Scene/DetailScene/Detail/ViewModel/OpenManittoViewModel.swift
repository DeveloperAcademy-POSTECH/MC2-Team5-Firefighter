//
//  OpenManittoViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/18/23.
//

import Combine
import Foundation

final class OpenManittoViewModel: BaseViewModelType {

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    struct Output {
        let friendList: AnyPublisher<Result<FriendList, Error>, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: OpenManittoUsecase
    private let roomId: String
    private let manittoNickname: String

    // MARK: - init

    init(usecase: OpenManittoUsecase,
         roomId: String,
         manittoNickname: String) {
        self.usecase = usecase
        self.roomId = roomId
        self.manittoNickname = manittoNickname
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let friendList = input.viewDidLoad
            .compactMap { [weak self] in return self }
            .asyncMap { await $0.fetchFriendList() }
            .eraseToAnyPublisher()

        return Output(
            friendList: friendList
        )
    }

    // MARK: - Private - func

    private func fetchFriendList() async -> Result<FriendList, Error> {
        do {
            let list = try await self.usecase.fetchFriendList(roomId: self.roomId)
            return .success(list)
        } catch(let error) {
            return .failure(error)
        }
    }
}

