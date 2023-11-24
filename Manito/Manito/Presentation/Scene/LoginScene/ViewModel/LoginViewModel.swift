//
//  LoginViewModel.swift
//  Manito
//
//  Created by COBY_PRO on 10/24/23.
//

import AuthenticationServices
import Combine
import Foundation

final class LoginViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let usecase: LoginUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let isNewLoginSubject: PassthroughSubject<Result<Bool, LoginUsecaseError>, Never> = PassthroughSubject()
    
    struct Input {
        let appleSignButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isNewLogin: AnyPublisher<Result<Bool, LoginUsecaseError>, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.appleSignButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.didTapAppleSignButton()
            })
            .store(in: &self.cancellable)
        return Output(isNewLogin: self.isNewLoginSubject.eraseToAnyPublisher())
    }
    
    // MARK: - init
    
    init(usecase: LoginUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - func
    
    private func didTapAppleSignButton() {
        let provider = ASAuthorizationAppleIDProvider()
        
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    // MARK: - network
    
    private func dispatchLogin(login: LoginRequestDTO) {
        Task {
            do {
                let login = try await self.usecase.dispatchAppleLogin(login: login)
                
                UserDefaultHandler.setIsLogin(isLogin: true)
                UserDefaultHandler.setAccessToken(accessToken: login.accessToken)
                UserDefaultHandler.setRefreshToken(refreshToken: login.refreshToken)
                
                if !login.isNewMember {
                    UserDefaultHandler.setNickname(nickname: login.nickname)
                    UserDefaultHandler.setIsSetFcmToken(isSetFcmToken: true)
                }
                
                self.isNewLoginSubject.send(.success(login.isNewMember))
            } catch {
                self.isNewLoginSubject.send(.failure(LoginUsecaseError.failedToLogin))
            }
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.isNewLoginSubject.send(.failure(LoginUsecaseError.failedCredential))
            return
        }
        guard let token = credential.identityToken else {
            self.isNewLoginSubject.send(.failure(LoginUsecaseError.failedToken))
            return
        }
        guard let tokenToString = String(data: token, encoding: .utf8) else {
            self.isNewLoginSubject.send(.failure(LoginUsecaseError.failedTokenToString))
            return
        }
        
        let loginDTO = LoginRequestDTO(identityToken: tokenToString, 
                                       fcmToken: UserDefaultStorage.fcmToken)
        self.dispatchLogin(login: loginDTO)
    }
}
