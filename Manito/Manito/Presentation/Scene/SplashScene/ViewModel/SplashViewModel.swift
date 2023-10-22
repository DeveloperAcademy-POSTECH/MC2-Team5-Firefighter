//
//  SplashViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/16/23.
//

import Combine
import Foundation

final class SplashViewModel: BaseViewModelType {

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    struct Output {
        let entryType: AnyPublisher<EntryType, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: SplashUsecase

    // MARK: - init

    init(usecase: SplashUsecase) {
        self.usecase = usecase
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let entryType = input.viewDidLoad
            .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .compactMap { [weak self] _ in self?.usecase.entryType }
            .eraseToAnyPublisher()

        return Output(
            entryType: entryType
        )
    }
}
