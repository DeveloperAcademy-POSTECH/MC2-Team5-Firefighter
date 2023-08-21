//
//  CreateRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/08/08.
//

import Combine
import Foundation

final class CreateRoomViewModel {
    
    // MARK: - property
    
    private var cancellable = Set<AnyCancellable>()
    
    struct Input {
        let textFieldText: AnyPublisher<String, Never>
    }
    
    struct Output {
        let textCount: AnyPublisher<Int, Never>
    }
    
    func transform(_ input: Input) -> Output {
        let textCount = input.textFieldText
            .map { text in
                return text.count
            }
            .eraseToAnyPublisher()
        
        return Output(textCount: textCount)
    }
    
    // MARK: - init
    
    
    
    // MARK: - func
    
    
    
    // MARK: - network
}
