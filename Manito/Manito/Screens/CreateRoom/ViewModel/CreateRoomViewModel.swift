//
//  CreateRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/08/08.
//

import Combine
import Foundation

final class CreateRoomViewModel: ViewModelType {
    
    // MARK: - property
    
    private let createRoomService: CreateRoomService
    private var cancellable = Set<AnyCancellable>()
    
    private let roomIdSubject = PassthroughSubject<Int, NetworkError>()
    
    struct Input {
        let textFieldTextDidChanged: AnyPublisher<String, Never>
        let sliderValueDidChanged: AnyPublisher<Int, Never>
        let calendarDateDidTap: AnyPublisher<String, Never>
        let nextButtonDidTap: AnyPublisher<CreateRoomStep, Never>
    }
    
    struct Output {
        let title: AnyPublisher<String, Never>
        let capacity: AnyPublisher<Int, Never>
        let date: AnyPublisher<String, Never>
        let currentStep: AnyPublisher<CreateRoomStep, Never>
    }
    
    func transform(from input: Input) -> Output {
        let text = input.textFieldTextDidChanged
            .map { text in
                return text
            }
            .eraseToAnyPublisher()
        
        let capacity = input.sliderValueDidChanged
            .map { value in
                return Int(value)
            }
            .eraseToAnyPublisher()
        
        let date = input.calendarDateDidTap
            .map { date in
                return date
            }
            .eraseToAnyPublisher()
        
        let step = input.nextButtonDidTap
            .map { currentStep -> CreateRoomStep in
                if currentStep == .chooseCharacter {
                    // viewModel 에 request api 만들고 실행 여기서
                    
                    print("네트워크 통신")
                }
                return currentStep
            }
            .eraseToAnyPublisher()
        
        return Output(title: text,
                      capacity: capacity,
                      date: date,
                      currentStep: step)
    }
    
    // MARK: - init
    
    init(createRoomService: CreateRoomService) {
        self.createRoomService = createRoomService
    }
    
    // MARK: - func
    
    
    
    // MARK: - network
    
    private func requestCreateRoom(room: CreateRoomDTO) {
        Task {
            do {
                let roomId = try await self.createRoomService.postCreateRoom(body: room)
                self.roomIdSubject.send(roomId)
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.roomIdSubject.send(completion: .failure(error))
            }
        }
    }
}
