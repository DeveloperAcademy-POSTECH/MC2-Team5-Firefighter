//
//  FriendListUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/19/23.
//

import Combine
import Foundation

protocol FriendListUsecase {
    func fetchFriendList(roomId: String) async throws -> FriendList
}

final class FriendListUsecaseImpl: FriendListUsecase {

    // MARK: - property

    private let repository: DetailRoomRepository

    // MARK: - init

    init(repository: DetailRoomRepository) {
        self.repository = repository
    }

    // MARK: - Public - func
    
    func fetchFriendList(roomId: String) async throws -> FriendList {
        do {
            let friendListData = try await self.repository.fetchWithFriend(roomId: roomId)
            return friendListData.toFriendList()
        } catch {
            throw DetailUsecaseError.failedToFetchFriend
        }
    }
}

