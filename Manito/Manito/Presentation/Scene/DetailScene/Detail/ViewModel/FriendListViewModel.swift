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
        let friendList: AnyPublisher<Result<[MemberInfo], Error>, Never>
    }

    // MARK: - property

    private let usecase: FriendListUsecase
    private let roomId: String

    // MARK: - init

    init(usecase: FriendListUsecase,
         roomId: String) {
        self.usecase = usecase
        self.roomId = roomId
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let friendList = input.viewDidLoad
            .compactMap { [weak self] in return self }
            .asyncMap { viewModel -> Result<[MemberInfo], Error> in
                do {
                    let list = try await viewModel.usecase.fetchFriendList(roomId: viewModel.roomId)
                    return .success(list.members)
                } catch(let error) {
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        return Output(friendList: friendList)
    }
}
