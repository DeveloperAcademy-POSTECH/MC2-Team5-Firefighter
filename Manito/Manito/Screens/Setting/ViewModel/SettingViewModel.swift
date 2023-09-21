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
    
    private let settingService: SettingService
    private var cancellable = Set<AnyCancellable>()
    
    private let deleteUserSubject = PassthroughSubject<Void, NetworkError>()
    private let logoutSubject = PassthroughSubject<Void, Never>()
    
    struct Input {
        let withdrawalButtonDidTap: AnyPublisher<Void, Never>
        let logoutButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let deleteUser: PassthroughSubject<Void, NetworkError>
        let logout: PassthroughSubject<Void, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.withdrawalButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.requestDeleteUser()
            })
            .store(in: &self.cancellable)
        
        input.logoutButtonDidTap
            .sink { [weak self] _ in
                UserDefaultHandler.clearAllDataExcludingFcmToken()
                self?.logoutSubject.send()
            }
            .store(in: &self.cancellable)
        
        return Output(deleteUser: self.deleteUserSubject,
                      logout: self.logoutSubject)
    }
    
    // MARK: - init
    
    init(settingService: SettingService) {
        self.settingService = settingService
    }
    
    // MARK: - func
    
    private func requestDeleteUser() {
        Task {
            do {
                let statusCode = try await self.settingService.deleteUser()
                switch statusCode {
                case 200..<300:
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
