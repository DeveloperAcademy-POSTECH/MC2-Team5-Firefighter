//
//  SettingViewModel.swift
//  Manito
//
//  Created by 이성호 on 2023/09/01.
//

import Combine
import Foundation

final class SettingViewModel: BaseViewModelType {
    
    struct Input {
        let logoutButtonDidTap: AnyPublisher<Void, Never>
        let withdrawalButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let logout: AnyPublisher<Void, Never>
        let deleteUser: AnyPublisher<Result<Void, Error>, Never>
    }
    
    // MARK: - property
    
    private let usecase: SettingUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let logoutSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    // MARK: - init
    
    init(usecase: SettingUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        
        input.logoutButtonDidTap
            .sink { [weak self] _ in
                UserDefaultHandler.clearAllDataExcludingFcmToken()
                self?.logoutSubject.send()
            }
            .store(in: &self.cancellable)
    
        let deleteUser = input.withdrawalButtonDidTap
            .asyncMap { [weak self] _ -> Result<Void, Error> in
                do {
                    let _ = try await self?.deleteUser()
                    return .success(())
                } catch(let error) {
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        return Output(logout: self.logoutSubject.eraseToAnyPublisher(),
                      deleteUser: deleteUser)
    }
}

// MARK: - Helper

extension SettingViewModel {
    private func deleteUser() async throws {
        let _ = try await self.usecase.deleteUser()
        UserDefaultHandler.clearAllDataExcludingFcmToken()
    }
}
