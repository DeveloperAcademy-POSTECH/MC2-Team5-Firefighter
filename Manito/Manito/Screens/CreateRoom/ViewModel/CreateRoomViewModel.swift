//
//  CreateRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/08/08.
//

import Combine
import Foundation

final class CreateRoomViewModel: ViewModelType {
    
    typealias CurrentNextStep = (current: CreateRoomStep, next: CreateRoomStep)
    
    // MARK: - property
    
    let maxCount: Int = 8
    
    private let createRoomService: CreateRoomService
    private var cancellable = Set<AnyCancellable>()
    
    private let titleSubject = CurrentValueSubject<String, Never>("")
    private let capacitySubject = CurrentValueSubject<Int, Never>(4)
    private let startDateSubject = CurrentValueSubject<String, Never>("")
    private let endDateSubject = CurrentValueSubject<String, Never>("")
    private let dateRangeSubject = PassthroughSubject<String, Never>()
    private let characterIndexSubject = CurrentValueSubject<Int, Never>(0)
    private let roomIdSubject = PassthroughSubject<Int, NetworkError>()
    
    struct Input {
        let textFieldTextDidChanged: AnyPublisher<String, Never>
        let sliderValueDidChanged: AnyPublisher<Int, Never>
        let startDateDidTap: AnyPublisher<String, Never>
        let endDateDidTap: AnyPublisher<String, Never>
        let characterIndexDidTap: AnyPublisher<Int, Never>
        let nextButtonDidTap: AnyPublisher<CreateRoomStep, Never>
        let backButtonDidTap: AnyPublisher<CreateRoomStep, Never>
    }
    
    struct Output {
        let title: CurrentValueSubject<String, Never>
        let isOverMaxCount: AnyPublisher<Bool, Never>
        let capacity: CurrentValueSubject<Int, Never>
        let dateRange: PassthroughSubject<String, Never>
        let isEnabled: AnyPublisher<Bool, Never>
        let currentStep: AnyPublisher<CurrentNextStep, Never>
        let previousStep: AnyPublisher<CreateRoomStep, Never>
        let roomId: PassthroughSubject<Int, NetworkError>
    }
    
    func transform(from input: Input) -> Output {
        input.textFieldTextDidChanged
            .sink(receiveValue: { [weak self] title in
                self?.titleSubject.send(title)
            })
            .store(in: &self.cancellable)
        
        let isOverMaxCount = input.textFieldTextDidChanged
            .map { [weak self] text -> Bool in
                return self?.isOverMaxCount(titleCount: text.count, maxCount: self?.maxCount ?? 0) ?? false
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
        
        let currentStep = input.nextButtonDidTap
            .map { [weak self] step -> CurrentNextStep in
                guard let self = self else { return (step, step.next()) }
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
            .eraseToAnyPublisher()
        
        let previousStep = input.backButtonDidTap
            .map { step -> CreateRoomStep in
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
            .eraseToAnyPublisher()
        
        return Output(title: self.titleSubject,
                      isOverMaxCount: isOverMaxCount,
                      capacity: self.capacitySubject,
                      dateRange: self.dateRangeSubject,
                      isEnabled: isEnabled,
                      currentStep: currentStep, previousStep: previousStep,
                      roomId: self.roomIdSubject)
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
    
    // MARK: - network
    
    private func requestCreateRoom(roomInfo: CreatedRoomInfoRequestDTO) {
        Task {
            do {
                let roomId = try await self.createRoomService.dispatchCreateRoom(room: CreatedRoomRequestDTO(room: CreatedRoomInfoRequestDTO(title: roomInfo.title,
                                                                                                                                             capacity: roomInfo.capacity,
                                                                                                                                             startDate: "20\(roomInfo.startDate)",
                                                                                                                                             endDate: "20\(roomInfo.endDate)")
                                                                                                             , member: MemberInfoRequestDTO(colorIndex: self.characterIndexSubject.value)))
                self.roomIdSubject.send(roomId)
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.roomIdSubject.send(completion: .failure(error))
            }
        }
    }
}
