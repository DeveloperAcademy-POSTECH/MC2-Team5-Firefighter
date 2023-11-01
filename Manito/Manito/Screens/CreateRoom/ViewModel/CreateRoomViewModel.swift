//
//  CreateRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/08/08.
//

import Combine
import Foundation

final class CreateRoomViewModel: BaseViewModelType {
    
    typealias CurrentNextStep = (current: CreateRoomStep, next: CreateRoomStep)
    typealias Counts = (textCount: Int, maxCount: Int)
    
    // MARK: - property
    
    private let maxCount: Int = 8
    
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
        let nextButtonDidTap: AnyPublisher<CreateRoomStep, Never>
        let backButtonDidTap: AnyPublisher<CreateRoomStep, Never>
    }
    
    struct Output {
        let title: AnyPublisher<String, Never>
        let counts: AnyPublisher<Counts, Never>
        let fixedTitleByMaxCount: AnyPublisher<String, Never>
        let capacity: AnyPublisher<Int, Never>
        let dateRange: AnyPublisher<String, Never>
        let isEnabled: AnyPublisher<Bool, Never>
        let currentNextStep: AnyPublisher<CurrentNextStep, Never>
        let previousStep: AnyPublisher<CreateRoomStep, Never>
        let roomId: AnyPublisher<Result<Int, Error>, Never>
    }
    
    func transform(from input: Input) -> Output {
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
                let isOverMaxCount = self?.isOverMaxCount(titleCount: text.count, maxCount: self?.maxCount ?? 0) ?? false
                
                if isOverMaxCount {
                    let endIndex = text.index(text.startIndex, offsetBy: self?.maxCount ?? 0)
                    let fixedText = text[text.startIndex..<endIndex]
                    self?.titleSubject.send(String(fixedText))
                    return String(fixedText)
                }
                
                self?.titleSubject.send(text)
                return text
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
        
        let currentNextStep = input.nextButtonDidTap
            .map { [weak self] step -> CurrentNextStep in
                guard let self = self else { return (step, step.next()) }
                return self.runActionByStep(step: step)
            }
            .eraseToAnyPublisher()
        
        let previousStep = input.backButtonDidTap
            .map { [weak self] step -> CreateRoomStep in
                guard let self = self else { return step }
                return self.previous(step: step)
            }
            .eraseToAnyPublisher()
        
        return Output(title: self.titleSubject.eraseToAnyPublisher(), 
                      counts: mergeCount,
                      fixedTitleByMaxCount: fixedTitle,
                      capacity: self.capacitySubject.eraseToAnyPublisher(),
                      dateRange: self.dateRangeSubject.eraseToAnyPublisher(),
                      isEnabled: isEnabled,
                      currentNextStep: currentNextStep, previousStep: previousStep,
                      roomId: self.roomIdSubject.eraseToAnyPublisher())
    }
    
    // MARK: - init
    
    init(createRoomService: CreateRoomService) {
        self.createRoomService = createRoomService
    }
    
    // MARK: - func
    
    private func isOverMaxCount(titleCount: Int, maxCount: Int) -> Bool {
        if titleCount > maxCount { return true }
        else { return false }
    }
    
    private func runActionByStep(step: CreateRoomStep) -> CurrentNextStep {
        switch step {
        case .chooseCharacter:
            self.requestCreateRoom(roomInfo: CreatedRoomInfoRequestDTO(title: self.titleSubject.value,
                                                                       capacity: self.capacitySubject.value,
                                                                       startDate: self.startDateSubject.value,
                                                                       endDate: self.endDateSubject.value))
            return (step, step.next())
        default:
            return (step, step.next())
        }
    }
    
    private func previous(step: CreateRoomStep) -> CreateRoomStep {
        switch step {
        case .inputTitle:
            return .inputTitle
        case .inputCapacity:
            return .inputTitle
        case .inputDate:
            return .inputCapacity
        case .checkRoom:
            return .inputDate
        case .chooseCharacter:
            return .checkRoom
        }
    }
    
    // MARK: - network
    
    private func requestCreateRoom(roomInfo: CreatedRoomInfoRequestDTO) {
        Task {
            do {
                let roomId = try await self.createRoomService.dispatchCreateRoom(room: CreatedRoomRequestDTO(room: CreatedRoomInfoRequestDTO(title: roomInfo.title,
                                                                                                                                             capacity: roomInfo.capacity,
                                                                                                                                             startDate: "20\(roomInfo.startDate)",
                                                                                                                                             endDate: "20\(roomInfo.endDate)"),
                                                                                                             member: MemberInfoRequestDTO(colorIndex: self.characterIndexSubject.value)))
                self.roomIdSubject.send(.success(roomId))
            } catch(let error) {
                self.roomIdSubject.send(.failure(error))
            }
        }
    }
}
