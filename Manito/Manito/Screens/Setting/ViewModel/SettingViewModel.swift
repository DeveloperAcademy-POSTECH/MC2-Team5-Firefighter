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
    
    struct Input {
        let withdrawalButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let deleteUser: PassthroughSubject<Void, NetworkError>
    }
    
    func transform(from input: Input) -> Output {
        input.withdrawalButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.requestDeleteUser()
            })
            .store(in: &self.cancellable)
        
        return Output(deleteUser: self.deleteUserSubject)
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
