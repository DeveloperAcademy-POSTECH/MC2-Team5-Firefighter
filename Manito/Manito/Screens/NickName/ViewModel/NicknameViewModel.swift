//
//  NicknameViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/02.
//

import Combine
import Foundation

final class NicknameViewModel: BaseViewModelType {
    
    typealias Counts = (textCount: Int, maxCount: Int)
    
    // MARK: - property
    
    private let maxCount: Int = 5
    
    private let nicknameUsecase: NicknameUsecase
    private let textFieldUsecase: TextFieldUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let nicknameSubject: CurrentValueSubject<String, Never> = CurrentValueSubject("")
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let textFieldDidChanged: AnyPublisher<String, Never>
        let doneButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let nickname: AnyPublisher<String, Never>
        let counts: AnyPublisher<Counts, Never>
        let fixedTitleByMaxCount: AnyPublisher<String, Never>
        let isEnabled: AnyPublisher<Bool, Never>
        let doneButton: AnyPublisher<Result<Void, Error>, Never>
    }
    
    // MARK: - init
    
    init(nicknameUsecase: NicknameUsecase,
         textFieldUsecase: TextFieldUsecase) {
        self.nicknameUsecase = nicknameUsecase
        self.textFieldUsecase = textFieldUsecase
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        let nickname = input.viewDidLoad
            .map { UserDefaultStorage.nickname }
            .eraseToAnyPublisher()

        let changeTypeCount = input.viewDidLoad
            .map { [weak self] _ -> Counts in
                return (UserDefaultStorage.nickname.count, self?.maxCount ?? 0)
            }
        
        let createTypeCount = input.textFieldDidChanged
            .map { [weak self] text -> Counts in
                self?.nicknameSubject.send(text)
                return (text.count, self?.maxCount ?? 0)
            }
        
        let mergeCount = Publishers.Merge(createTypeCount, changeTypeCount).eraseToAnyPublisher()
        
        let fixedTitle = input.textFieldDidChanged
            .map { [weak self] text -> String in
                guard let self else { return "" }
                let text = self.textFieldUsecase.cutTextByMaxCount(text: text, maxCount: self.maxCount)
                return text
            }
            .eraseToAnyPublisher()
        
        let isEnabled = input.textFieldDidChanged
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
        
        let doneButtonDidTap = input.doneButtonDidTap
            .asyncMap { [weak self] _  -> Result<Void, Error> in
                do {
                    let nickname = self?.nicknameSubject.value
                    self?.saveNicknameToUserDefault(nickname: nickname ?? "")
                    let _ = try await self?.putUserInfo(nickname: NicknameDTO(nickname: nickname ?? ""))
                    return .success(())
                } catch (let error) {
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()
        
        return Output(nickname: nickname,
                      counts: mergeCount,
                      fixedTitleByMaxCount: fixedTitle,
                      isEnabled: isEnabled,
                      doneButton: doneButtonDidTap)
    }
    
    private func saveNicknameToUserDefault(nickname: String) {
        UserData.setValue(nickname, forKey: .nickname)
        UserDefaultHandler.setIsSetFcmToken(isSetFcmToken: true)
    }
}

// MARK: - Helper

extension NicknameViewModel {
    private func putUserInfo(nickname: NicknameDTO) async throws -> Int {
        return try await self.nicknameUsecase.putUserInfo(nickname: nickname)
    }
}
