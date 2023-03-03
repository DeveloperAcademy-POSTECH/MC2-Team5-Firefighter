//
//  CreateLetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/01.
//

import Foundation

struct CreateLetterViewModel {

    // MARK: - property

    private let letterSevice: LetterAPI = LetterAPI(apiService: APIService())
    private let manitteeId: String
    private let roomId: String

    init(manitteeId: String, roomId: String) {
        self.manitteeId = manitteeId
        self.roomId = roomId
    }
}

extension CreateLetterViewModel {
    struct Input {
//        let sendLetterButtonDidTappedEvent:
    }

    struct Output {

    }

    func transform(from input: Input) -> Output {
        return Output()
    }
}
