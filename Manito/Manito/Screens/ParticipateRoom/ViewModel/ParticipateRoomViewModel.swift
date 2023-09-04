//
//  ParticipateRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/04.
//

import Combine
import Foundation

final class ParticipateRoomViewModel: ViewModelType {
    
    typealias Counts = (textCount: Int, maxCount: Int)
    
    // MARK: - property
    
    private let maxCount: Int = 6
    private let nextButtonSubject = PassthroughSubject<Void, NetworkError>()
    
    private let participateRoomService: ParticipateRoomService
    private var cancellable = Set<AnyCancellable>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let textFieldDidChanged: AnyPublisher<String, Never>
        let nextButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let counts: AnyPublisher<Counts, Never>
        let isEnabled: AnyPublisher<Bool, Never>
        let nextButton: PassthroughSubject<Void, NetworkError>
    }
    
    func transform(from input: Input) -> Output {
        let countViewDidLoadType = input.viewDidLoad
            .map { [weak self] _ -> Counts in
                (0, self?.maxCount ?? 0)
            }
        
        let countTextFieldDidChangedType = input.textFieldDidChanged
            .map { [weak self] text -> Counts in
                return (text.count, self?.maxCount ?? 0)
            }
        
        let mergeCount = Publishers.Merge(countViewDidLoadType, countTextFieldDidChangedType)
            .eraseToAnyPublisher()
        
        let isEnabled = input.textFieldDidChanged
            .map { text -> Bool in
                return !text.isEmpty
            }
            .eraseToAnyPublisher()
        
        input.nextButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                // request
                print("request API")
            })
            .store(in: &self.cancellable)
        
        return Output(counts: mergeCount,
                      isEnabled: isEnabled,
                      nextButton: self.nextButtonSubject)
    }
    
    // MARK: - init
    
    init(participateRoomService: ParticipateRoomService) {
        self.participateRoomService = participateRoomService
    }
    
    // MARK: - func
    
    
    // MARK: - network
    
}
