//
//  SelectManitteeViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/18/23.
//

import Combine
import Foundation

final class SelectManitteeViewModel: BaseViewModelType {
    
    enum Step: Int {
        case showJoystick = 0, showCapsule, openName, openButton
    }

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let swapView: AnyPublisher<Void, Never>
        let confirmButtonDidTap: AnyPublisher<Void, Never>
    }

    struct Output {
        let currentType: AnyPublisher<(step: Step, nickname: String), Never>
        let roomId: AnyPublisher<String, Never>
    }

    // MARK: - property

    private var cancelBag: Set<AnyCancellable> = Set()
    
    private var currentType: Step = .showJoystick
    
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
        let viewDidLoadPublisher = input.viewDidLoad
            .compactMap { [weak self] in self?.initType() }
            .eraseToAnyPublisher()
        
        let swapPublisher = input.swapView
            .compactMap { [weak self] in self?.nextType() }
            .eraseToAnyPublisher()
            
        let currentType = Publishers.Merge(viewDidLoadPublisher, swapPublisher)
            .eraseToAnyPublisher()
        
        let roomId = input.confirmButtonDidTap
            .compactMap { [weak self] in self?.roomId }
            .eraseToAnyPublisher()

        return Output(
            currentType: currentType,
            roomId: roomId
        )
    }

    // MARK: - Private - func
    
    private func initType() -> (step: Step, nickname: String) {
        return (step: self.currentType, nickname: self.manitteeNickname)
    }
    
    private func nextType() -> (step: Step, nickname: String) {
        guard let currentType = Step(rawValue: self.currentType.rawValue + 1) else { return (.showJoystick, "") }
        self.currentType = currentType
        return (step: currentType, nickname: self.manitteeNickname)
    }
}
