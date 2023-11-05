//
//  ParticipateRoomViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/04.
//

import Combine
import Foundation

final class ParticipateRoomViewModel: BaseViewModelType {
    
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
        let roomInfo: AnyPublisher<Result<ParticipatedRoomInfo, ParticipateRoomError>, Never>
    }
    
    // MARK: - property
    
    private let maxCount: Int = 6
    
    private let usecase: ParticipateRoomUsecase
    private let textFieldUsecase: TextFieldUsecase
    
    private var cancellable: Set<AnyCancellable> = Set()
    
    // MARK: - init
    
    init(usecase: ParticipateRoomUsecase,
         textFieldUsecase: TextFieldUsecase) {
        self.usecase = usecase
        self.textFieldUsecase = textFieldUsecase
    }
    
    // MARK: - func
    
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
                guard let self else { return "" }
                let code = self.textFieldUsecase.cutTextByMaxCount(text: text, maxCount: self.maxCount)
                return code
            }
            .eraseToAnyPublisher()
        
        let isEnabled = input.textFieldDidChanged
            .map { $0.count == 6 }
            .eraseToAnyPublisher()
        
        let roomInfo = input.nextButtonDidTap
            .asyncMap({ [weak self] code -> Result<ParticipatedRoomInfo, ParticipateRoomError> in
                do {
                    let roomInfo = try await self?.dispatchVerifyCode(code)
                    return .success(roomInfo ?? ParticipatedRoomInfo.emptyInfo)
                } catch (let error) {
                    return .failure(error as! ParticipateRoomError)
                }
            })
            .eraseToAnyPublisher()
            
        return Output(counts: mergeCount,
                      fixedTitleByMaxCount: fixedTitle,
                      isEnabled: isEnabled,
                      roomInfo: roomInfo)
    }
}

// MARK: - Helper

extension ParticipateRoomViewModel {
    private func dispatchVerifyCode(_ code: String) async throws -> ParticipatedRoomInfo {
        return try await self.usecase.dispatchVerifyCode(code: code).toParticipateRoomInfo()
    }
}
