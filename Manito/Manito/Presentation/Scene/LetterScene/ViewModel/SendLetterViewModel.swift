//
//  SendLetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/23.
//

import Combine
import Foundation

final class SendLetterViewModel: BaseViewModelType {

    struct Input {

    }

    struct Output {

    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()

    private let usecase: SendLetterUsecase

    // MARK: - init

    init(usecase: SendLetterUsecase,
         mission: String,
         manitteeId: String,
         roomId: String,
         missionId: String) {
        self.usecase = usecase
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        return Output()
    }

    // MARK: - Private - func

    
}
