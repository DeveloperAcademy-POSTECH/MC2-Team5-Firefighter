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
        let textFieldTextDidChanged: AnyPublisher<String, Never>
        let sliderValueDidChanged: AnyPublisher<Int, Never>
        let nextButtonDidTap: AnyPublisher<CreateRoomStep, Never>
    }
    
    struct Output {
        let textCount: AnyPublisher<Int, Never>
        let capacity: AnyPublisher<Int, Never>
        let currentStep: AnyPublisher<CreateRoomStep, Never>
    }
    
    func transform(_ input: Input) -> Output {
        let textCount = input.textFieldTextDidChanged
            .map { text in
                return text.count
            }
            .eraseToAnyPublisher()
        
        let capacity = input.sliderValueDidChanged
            .map { value in
                return Int(value)
            }
            .eraseToAnyPublisher()
        
        let step = input.nextButtonDidTap
            .map { currentStep -> CreateRoomStep in
                return currentStep
            }
            .eraseToAnyPublisher()
        
        return Output(textCount: textCount,
                      capacity: capacity,
                      currentStep: step)
    }
    
    // MARK: - init
    
    
    
    // MARK: - func
    
    
    
    // MARK: - network
}
