//
//  LetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

final class LetterViewModel: ViewModelType {

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let segmentControlValueChanged: CurrentValueSubject<Int, Never>
        let refresh: PassthroughSubject<Void, Never>
    }

    struct Output {
        let letterSubject: PassthroughSubject<Letter, NetworkError>
    }

    // MARK: - property

    private let service: Servicable

    // MARK: - init

    init(service: Servicable) {
        self.service = service
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        return Output()
    }

    // MARK: - Private - func

}
