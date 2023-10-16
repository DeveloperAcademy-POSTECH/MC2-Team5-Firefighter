//
//  MemoryUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Combine
import Foundation

protocol MemoryUsecase {
    func fetchMemory(roomId: String) async throws -> Memory
}

final class MemoryUsecaseImpl: MemoryUsecase {

    // MARK: - property

    private let repository: DetailRoomRepository

    // MARK: - init

    init(repository: DetailRoomRepository) {
        self.repository = repository
    }

    // MARK: - Public - func
    
    func fetchMemory(roomId: String) async throws -> Memory {
        do {
            let memoryData = try await self.repository.fetchMemory(roomId: roomId)
            return await memoryData.toMemory()
        } catch {
            throw DetailUsecaseError.failedToFetchMemory
        }
    }
}

