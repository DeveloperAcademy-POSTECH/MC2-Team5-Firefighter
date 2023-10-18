//
//  OpenManittoUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/18/23.
//

import Combine
import Foundation

protocol OpenManittoUsecase {
    var userNickname: String { get }
    
    func fetchFriendList(roomId: String) async throws -> FriendList
}

final class OpenManittoUsecaseImpl: OpenManittoUsecase {
    
    // MARK: - property
    
    var userNickname: String {
        return UserDefaultStorage.nickname
    }

    private let repository: DetailRoomRepository

    // MARK: - init

    init(repository: DetailRoomRepository) {
        self.repository = repository
    }

    // MARK: - Public - func
    
    func fetchFriendList(roomId: String) async throws -> FriendList {
        do {
            let data = try await self.repository.fetchWithFriend(roomId: roomId)
            return data.toFriendList()
        } catch {
            throw DetailUsecaseError.failedToFetchFriend
        }
    }
}
