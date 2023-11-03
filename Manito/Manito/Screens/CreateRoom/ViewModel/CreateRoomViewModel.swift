//
//  CreateRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/08/08.
//

import Combine
import Foundation

final class CreateRoomViewModel: BaseViewModelType {
    
    typealias Counts = (textCount: Int, maxCount: Int)
    typealias StepButtonState = (step: Step, isEnabled: Bool)
    
    struct RoomInfo {
        let title: String
        let capacity: Int
        let dateRange: String
    }
    
    enum Step: Int {
        case title = 0, capacity, date, roomInfo, character
        
        func next() -> Self {
            switch self {
            case .title:
                return .capacity
            case .capacity:
                return .date
            case .date:
                return .roomInfo
            case .roomInfo:
                return .character
            case .character:
                return .character
            }
        }
        
        func previous() -> Self {
            switch self {
            case .title:
                return .title
            case .capacity:
                return .title
            case .date:
                return .capacity
            case .roomInfo:
                return .date
            case .character:
                return .roomInfo
            }
        }
    }
    
    // MARK: - property
    
    private let maxCount: Int = 8
    private var currentStep: Step = .title
    
    private let usecase: CreateRoomUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let titleSubject: CurrentValueSubject<String, Never> = CurrentValueSubject("")
    private let capacitySubject:CurrentValueSubject<Int, Never> = CurrentValueSubject(4)
    private let startDateSubject: CurrentValueSubject<String, Never> = CurrentValueSubject("")
    private let endDateSubject: CurrentValueSubject<String, Never> = CurrentValueSubject("")
    private let dateRangeSubject: PassthroughSubject<String, Never> = PassthroughSubject()
    private let characterIndexSubject: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    private let roomIdSubject: PassthroughSubject<Result<Int, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let textFieldTextDidChanged: AnyPublisher<String, Never>
        let sliderValueDidChanged: AnyPublisher<Int, Never>
        let startDateDidTap: AnyPublisher<String, Never>
        let endDateDidTap: AnyPublisher<String, Never>
        let characterIndexDidTap: AnyPublisher<Int, Never>
        let nextButtonDidTap: AnyPublisher<Void, Never>
        let backButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let currentStep: AnyPublisher<StepButtonState, Never>
        let counts: AnyPublisher<Counts, Never>
        let fixedTitleByMaxCount: AnyPublisher<String, Never>
        let capacity: AnyPublisher<Int, Never>
        let isEnabled: AnyPublisher<Bool, Never>
        let roomId: AnyPublisher<Result<Int, Error>, Never>
        let roomInfo: AnyPublisher<RoomInfo, Never>
    }
    
    func transform(from input: Input) -> Output {
        let viewDidLoad = input.viewDidLoad
            .compactMap { [weak self] in self?.initStep() }
            .eraseToAnyPublisher()
        
        let nextButtonDidTap = input.nextButtonDidTap
            .compactMap { [weak self] in self?.nextStep() }
            .eraseToAnyPublisher()
        
        let previousStep = input.backButtonDidTap
            .compactMap { [weak self] in self?.previousStep() }
            .eraseToAnyPublisher()
        
        let currentStep = Publishers.Merge3(viewDidLoad, nextButtonDidTap, previousStep)
            .eraseToAnyPublisher()
        
        let countViewDidLoadType = input.viewDidLoad
            .map { [weak self] _ -> Counts in
                (0, self?.maxCount ?? 0)
            }
        
        let countTextFieldDidChangedType = input.textFieldTextDidChanged
            .map { [weak self] text -> Counts in
                (text.count, self?.maxCount ?? 0)
            }
        
        let mergeCount = Publishers.Merge(countViewDidLoadType, countTextFieldDidChangedType).eraseToAnyPublisher()
        
        let fixedTitle = input.textFieldTextDidChanged
            .map { [weak self] text -> String in
                guard let self else { return "" }
                let title = self.cutTextByMaxCount(text: text, maxCount: self.maxCount)
                self.titleSubject.send(title)
                return title
            }
            .eraseToAnyPublisher()
        
        input.sliderValueDidChanged
            .sink(receiveValue: { [weak self] capacity in
                self?.capacitySubject.send(capacity)
            })
            .store(in: &self.cancellable)
        
        input.startDateDidTap
            .sink(receiveValue: { [weak self] startDate in
                self?.startDateSubject.send(startDate)
            })
            .store(in: &self.cancellable)
        
        input.endDateDidTap
            .sink(receiveValue: { [weak self] endDate in
                self?.endDateSubject.send(endDate)
                if let startDate = self?.startDateSubject.value {
                    let range = "\(startDate) ~ \(endDate)"
                    self?.dateRangeSubject.send(range)
                }
            })
            .store(in: &self.cancellable)
        
        let isEnabledTitleType = input.textFieldTextDidChanged
            .map { !$0.isEmpty }
    
        let isEnabledDateType = input.endDateDidTap
            .map { !$0.isEmpty }
        
        let isEnabled = Publishers.Merge(isEnabledTitleType, isEnabledDateType)
            .eraseToAnyPublisher()
        
        input.characterIndexDidTap
            .sink(receiveValue: { [weak self] index in
                self?.characterIndexSubject.send(index)
            })
            .store(in: &self.cancellable)
        
        let roomInfo = Publishers.CombineLatest3(self.titleSubject, 
                                                 self.capacitySubject,
                                                 self.dateRangeSubject)
            .map { title, capacity, date in
                return RoomInfo(title: title, 
                                capacity: capacity,
                                dateRange: date)
            }
            .eraseToAnyPublisher()
        
        return Output(currentStep: currentStep,
                      counts: mergeCount,
                      fixedTitleByMaxCount: fixedTitle,
                      capacity: self.capacitySubject.eraseToAnyPublisher(),
                      isEnabled: isEnabled,
                      roomId: self.roomIdSubject.eraseToAnyPublisher(), 
                      roomInfo: roomInfo)
    }
    
    // MARK: - init
    
    init(usecase: CreateRoomUsecaseImpl) {
        self.usecase = usecase
    }
    
    // MARK: - func
    
    private func cutTextByMaxCount(text: String, maxCount: Int) -> String {
        let isOverMaxCount = self.isOverMaxCount(titleCount: text.count, maxCount: maxCount)
        
        if isOverMaxCount {
            let endIndex = text.index(text.startIndex, offsetBy: maxCount)
            let fixedText = text[text.startIndex..<endIndex]
            return String(fixedText)
        }
        return text
    }
    
    private func isOverMaxCount(titleCount: Int, maxCount: Int) -> Bool {
        return titleCount > maxCount ? true : false
    }
    
    private func initStep() -> StepButtonState {
        return (self.currentStep, false)
    }
    
    private func nextStep() -> StepButtonState {
        switch currentStep {
        case .capacity:
            self.currentStep = currentStep.next()
            return (self.currentStep, self.dateIsEmpty())
        case .character:
            let roomInfo = CreateRoomInfo(title: self.titleSubject.value,
                                          capacity: self.capacitySubject.value,
                                          startDate: self.startDateSubject.value,
                                          endDate: self.endDateSubject.value)
            self.dispatchCreateRoom(roomInfo: roomInfo)
            return (self.currentStep, true)
        default:
            self.currentStep = currentStep.next()
            return (self.currentStep, true)
        }
    }
    
    private func previousStep() -> StepButtonState {
        self.currentStep = currentStep.previous()
        return (self.currentStep, true)
    }
    
    private func dateIsEmpty() -> Bool {
        return self.endDateSubject.value.isEmpty ? false : true
    }
    
    // MARK: - network
    
    private func dispatchCreateRoom(roomInfo: CreateRoomInfo) {
        Task {
            do {
                let roomInfoDTO = roomInfo.toCreateRoomInfoDTO()
                let memberInfoDTO = MemberInfoRequestDTO(colorIndex: self.characterIndexSubject.value)
                let roomId = try await self.usecase.dispatchCreateRoom(room: CreatedRoomRequestDTO(room: roomInfoDTO,
                                                                                                             member: memberInfoDTO))
                self.roomIdSubject.send(.success(roomId))
            } catch(let error) {
                self.roomIdSubject.send(.failure(error))
            }
        }
    }
}
