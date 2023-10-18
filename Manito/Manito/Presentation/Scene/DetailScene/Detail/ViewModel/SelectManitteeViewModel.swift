//
//  SelectManitteeViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/18/23.
//

import Combine
import Foundation

final class SelectManitteeViewModel: BaseViewModelType {

    struct Input {
        
    }

    struct Output {
        
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()
    
    private let roomId: String
    private let manitteeNickname: String

    // MARK: - init

    init(roomId: String,
         manitteeNickname: String) {
        self.roomId = roomId
        self.manitteeNickname = manitteeNickname
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        

        return Output()
    }

    // MARK: - Private - func
    
}
