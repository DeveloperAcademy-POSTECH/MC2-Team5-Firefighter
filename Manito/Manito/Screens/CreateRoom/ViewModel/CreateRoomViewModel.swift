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
        let textFieldValueChanged: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let title: AnyPublisher<String, Never>
    }
    
    func transform(_ input: Input) -> Output {
        
        let title = input.textFieldValueChanged
            .eraseToAnyPublisher()
        
        
        return Output(title: title)
    }
    // MARK: - init
    
    
    
    // MARK: - func
    
    
    
    // MARK: - network
}
