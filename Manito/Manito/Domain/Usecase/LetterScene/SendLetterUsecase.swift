//
//  SendLetterUsecase.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/24.
//

import Combine
import Foundation

protocol SendLetterUsecase {

}

final class SendLetterUsecaseImpl: SendLetterUsecase {

    // MARK: - property

    private let repository: LetterRepository

    // MARK: - init

    init(repository: LetterRepository) {
        self.repository = repository
    }

    // MARK: - Public - func


}

