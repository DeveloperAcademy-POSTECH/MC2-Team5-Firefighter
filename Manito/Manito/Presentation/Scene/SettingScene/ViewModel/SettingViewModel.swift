//
//  SettingViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/01.
//

import Combine
import Foundation

final class SettingViewModel {
    
    // MARK: - property
    
    private let usecase: SettingUsecaseImpl
    private var cancellable = Set<AnyCancellable>()
    
    private let deleteUserSubject = PassthroughSubject<Void, NetworkError>()
    private let logoutSubject = PassthroughSubject<Void, Never>()
    
    struct Input {
        let logoutButtonDidTap: AnyPublisher<Void, Never>
        let withdrawalButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let logout: AnyPublisher<Void, Never>
        let deleteUser: AnyPublisher<Void, NetworkError>
    }
    
    func transform(from input: Input) -> Output {
        
        input.logoutButtonDidTap
            .sink { [weak self] _ in
                UserDefaultHandler.clearAllDataExcludingFcmToken()
                self?.logoutSubject.send()
            }
            .store(in: &self.cancellable)
            
        
        input.withdrawalButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.requestDeleteUser()
            })
            .store(in: &self.cancellable)

        return Output(logout: self.logoutSubject.eraseToAnyPublisher(),
                      deleteUser: self.deleteUserSubject.eraseToAnyPublisher())
    }
    
    // MARK: - init
    
    init(usecase: SettingUsecaseImpl) {
        self.usecase = usecase
    }
    
    // MARK: - func
    
    private func requestDeleteUser() {
        Task {
            do {
                let statusCode = try await self.usecase.deleteUser()
                switch statusCode {
                case 200..<300:
                    UserDefaultHandler.clearAllDataExcludingFcmToken()
                    self.deleteUserSubject.send()
                default:
                    self.deleteUserSubject.send(completion: .failure(.unknownError))
                }
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.deleteUserSubject.send(completion: .failure(error))
            }
        }
    }
}
