//
//  MemoryViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Combine
import Foundation

final class MemoryViewModel: BaseViewModelType {

    enum MessageType: Int {
        case sent = 0
        case received = 1
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let segmentControlValueChanged: PassthroughSubject<Int, Never>
    }

    struct Output {
        let memory: AnyPublisher<Result<Memory, Error>, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: MemoryUsecase
    private let roomId: String

    // MARK: - init

    init(usecase: MemoryUsecase,
         roomId: String) {
        self.usecase = usecase
        self.roomId = roomId
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let memoryResponse = input.viewDidLoad
            .compactMap { [weak self] in self }
            .asyncMap { viewModel -> Result<Memory, Error> in
                do {
                    let data = try await viewModel.fetchMemory()
                    return .success(data)
                } catch(let error) {
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        return Output(memory: memoryResponse)
    }

    // MARK: - Private - func

    private func fetchMemory() async throws -> Memory {
        return try await self.usecase.fetchMemory(roomId: self.roomId)
    }
}
