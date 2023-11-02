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
    
    private let createRoomService: CreateRoomSevicable
    private var cancellable = Set<AnyCancellable>()
    
    private let titleSubject = CurrentValueSubject<String, Never>("")
    private let capacitySubject = CurrentValueSubject<Int, Never>(4)
    private let startDateSubject = CurrentValueSubject<String, Never>("")
    private let endDateSubject = CurrentValueSubject<String, Never>("")
    private let dateRangeSubject = PassthroughSubject<String, Never>()
    private let characterIndexSubject = CurrentValueSubject<Int, Never>(0)
    private let roomIdSubject = PassthroughSubject<Result<Int, Error>, Never>()
    
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
                return self.cutTextByMaxCount(text: text)
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
            .map { title -> Bool in
                return !title.isEmpty
            }
    
        let isEnabledDateType = input.endDateDidTap
            .map { endDate -> Bool in
                return !endDate.isEmpty
            }
        
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
    
    init(createRoomService: CreateRoomService) {
        self.createRoomService = createRoomService
    }
    
    // MARK: - func
    
    private func cutTextByMaxCount(text: String) -> String {
        let isOverMaxCount = self.isOverMaxCount(titleCount: text.count, maxCount: self.maxCount)
        
        if isOverMaxCount {
            let endIndex = text.index(text.startIndex, offsetBy: self.maxCount)
            let fixedText = text[text.startIndex..<endIndex]
            self.titleSubject.send(String(fixedText))
            return String(fixedText)
        }
        
        self.titleSubject.send(text)
        return text
    }
    
    private func isOverMaxCount(titleCount: Int, maxCount: Int) -> Bool {
        if titleCount > maxCount { return true }
        else { return false }
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
                let roomId = try await self.createRoomService.dispatchCreateRoom(room: CreatedRoomRequestDTO(room: roomInfoDTO,
                                                                                                             member: memberInfoDTO))
                self.roomIdSubject.send(.success(roomId))
            } catch(let error) {
                self.roomIdSubject.send(.failure(error))
            }
        }
    }
}
