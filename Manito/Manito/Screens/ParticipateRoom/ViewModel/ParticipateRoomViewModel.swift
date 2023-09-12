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
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let textFieldDidChanged: AnyPublisher<String, Never>
        let nextButtonDidTap: AnyPublisher<String, Never>
    }
    
    struct Output {
        let counts: AnyPublisher<Counts, Never>
        let fixedTitleByMaxCount: AnyPublisher<String, Never>
        let isEnabled: AnyPublisher<Bool, Never>
        let roomInfo: PassthroughSubject<ParticipatedRoomInfo, Error>
    }
    
    // MARK: - property
    
    private let maxCount: Int = 6
    private let roomInfoSubject = PassthroughSubject<ParticipatedRoomInfo, Error>()

    private let participateRoomService: ParticipateRoomService
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - init
    
    init(participateRoomService: ParticipateRoomService) {
        self.participateRoomService = participateRoomService
    }
    
    // MARK: - func
    
    private func isOverMaxCount(titleCount: Int, maxCount: Int) -> Bool {
        if titleCount > maxCount { return true }
        else { return false }
    }
    
    func transform(from input: Input) -> Output {
        let countViewDidLoadType = input.viewDidLoad
            .map { [weak self] _ -> Counts in
                (0, self?.maxCount ?? 0)
            }
        
        let countTextFieldDidChangedType = input.textFieldDidChanged
            .map { [weak self] text -> Counts in
                (text.count, self?.maxCount ?? 0)
            }
        
        let mergeCount = Publishers.Merge(countViewDidLoadType, countTextFieldDidChangedType)
            .eraseToAnyPublisher()
        
        let fixedTitle = input.textFieldDidChanged
            .map { [weak self] text in
                let isOverMaxCount = self?.isOverMaxCount(titleCount: text.count, maxCount: self?.maxCount ?? 0) ?? false
                
                if isOverMaxCount {
                    let endIndex = text.index(text.startIndex, offsetBy: self?.maxCount ?? 0)
                    let fixedText = text[text.startIndex..<endIndex]
                    
                    return String(fixedText)
                }

                return text
            }
            .eraseToAnyPublisher()
        
        let isEnabled = input.textFieldDidChanged
            .map { $0.count == 6 }
            .eraseToAnyPublisher()
        
        input.nextButtonDidTap
            .sink(receiveValue: { [weak self] code in
                self?.requestParticipateRoom(code)
            })
            .store(in: &self.cancellable)
        
        return Output(counts: mergeCount,
                      fixedTitleByMaxCount: fixedTitle,
                      isEnabled: isEnabled,
                      roomInfo: self.roomInfoSubject)
    }
    
    // MARK: - network
    
    private func requestParticipateRoom(_ code: String) {
        Task {
            do {
                let data = try await self.participateRoomService.dispatchVerifyCode(code: code)
                self.roomInfoSubject.send(data.toParticipateRoomInfo())
            } catch(let error) {
                self.roomInfoSubject.send(completion: .failure(error))
            }
        }
    }
}
