//
//  MemoryUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Combine
import Foundation

protocol MemoryUsecase {
    var memory: Memory? { get set }
    
    func fetchMemory(roomId: String) async throws
}

final class MemoryUsecaseImpl: MemoryUsecase {

    // MARK: - property

    @Published var memory: Memory?
    
    private let repository: DetailRoomRepository

    // MARK: - init

    init(repository: DetailRoomRepository) {
        self.repository = repository
    }

    // MARK: - Public - func
    
    func fetchMemory(roomId: String) async throws {
        do {
            let memoryData = try await self.repository.fetchMemory(roomId: roomId)
            self.memory = await memoryData.toMemory()
        } catch {
            throw DetailUsecaseError.failedToFetchMemory
        }
    }
}

