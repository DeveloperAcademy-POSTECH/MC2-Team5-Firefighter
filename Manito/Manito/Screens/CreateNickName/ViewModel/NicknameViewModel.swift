//
//  NicknameViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/02.
//

import Combine
import Foundation

final class NicknameViewModel {
    
    // MARK: - property
    
    let maxCount: Int = 5
    
    private let nicknameService: NicknameService
    private var cancellable = Set<AnyCancellable>()
    
    private let nicknameSubject = CurrentValueSubject<String, Never>("")
    private let doneButtonSubject = PassthroughSubject<Void, NetworkError>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let textFieldDidChanged: AnyPublisher<String, Never>
        let doneButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let nickname: AnyPublisher<String, Never>
        let title: AnyPublisher<String, Never>
        let fixedTitleByMaxCount: AnyPublisher<String, Never>
        let isEnabled: AnyPublisher<Bool, Never>
        let doneButton: PassthroughSubject<Void, NetworkError>
    }
    
    func transform(from input: Input) -> Output {
        let nickname = input.viewDidLoad
            .map { _ -> String in
                let nickname = UserDefaultStorage.nickname
                return nickname
            }
            .eraseToAnyPublisher()
        
        let title = input.textFieldDidChanged
            .map { [weak self] text -> String in
                self?.nicknameSubject.send(text)
                return text
            }
            .eraseToAnyPublisher()
        
        let fixedTitle = input.textFieldDidChanged
            .map { [weak self] text -> String in
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
            .map { text -> Bool in
                return !text.isEmpty
            }
            .eraseToAnyPublisher()
        
        input.doneButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.didTapDoneButton()
            })
            .store(in: &self.cancellable)
        
        return Output(nickname: nickname,
                      title: title,
                      fixedTitleByMaxCount: fixedTitle,
                      isEnabled: isEnabled,
                      doneButton: self.doneButtonSubject)
    }
    
    // MARK: - init
    
    init(nicknameService: NicknameService) {
        self.nicknameService = nicknameService
    }
    
    // MARK: - func
    
    private func isOverMaxCount(titleCount: Int, maxCount: Int) -> Bool {
        if titleCount > maxCount { return true }
        else { return false }
    }
    
    private func didTapDoneButton() {
        let nickname = self.nicknameSubject.value
        UserData.setValue(nickname, forKey: .nickname)
        UserDefaultHandler.setIsSetFcmToken(isSetFcmToken: true)
        self.requestCreateNickname(nickname: NicknameDTO(nickname: nickname))
    }
    
    // MARK: - network
    
    private func requestCreateNickname(nickname: NicknameDTO) {
        Task {
            do {
                let statusCode = try await self.nicknameService.putUserInfo(nickname: nickname)
                switch statusCode {
                case 200..<300:
                    UserDefaultHandler.setNickname(nickname: nickname.nickname)
                    self.doneButtonSubject.send()
                default:
                    self.doneButtonSubject.send(completion: .failure(.unknownError))
                }
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.doneButtonSubject.send(completion: .failure(error))
            }
        }
    }
}
