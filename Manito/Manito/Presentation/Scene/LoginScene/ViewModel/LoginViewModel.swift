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
    private var cancellable = Set<AnyCancellable>()
    
    private let isNewMemberSubject = PassthroughSubject<Result<Bool, Error>, Never>()
    
    struct Input {
        let appleSignButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isNewMember: AnyPublisher<Result<Bool, Error>, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.appleSignButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.didTapAppleSignButton()
            })
            .store(in: &self.cancellable)
        return Output(isNewMember: self.isNewMemberSubject.eraseToAnyPublisher())
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
    
    private func requestLogin(login: LoginRequestDTO) {
        Task {
            do {
                let loginDTO = try await self.usecase.dispatchAppleLogin(login: login)
                
                UserDefaultHandler.setIsLogin(isLogin: true)
                UserDefaultHandler.setAccessToken(accessToken: loginDTO.accessToken ?? "")
                UserDefaultHandler.setRefreshToken(refreshToken: loginDTO.refreshToken ?? "")
                
                if let isNewMember = loginDTO.isNewMember {
                    if !isNewMember {
                        UserDefaultHandler.setNickname(nickname: loginDTO.nickname ?? "")
                        UserDefaultHandler.setIsSetFcmToken(isSetFcmToken: true)
                    }
                    
                    self.isNewMemberSubject.send(.success(isNewMember))
                }
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
            }
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let token = credential.identityToken else { return }
        guard let tokenToString = String(data: token, encoding: .utf8) else { return }
        
        let loginDTO = LoginRequestDTO(identityToken: tokenToString, fcmToken: UserDefaultStorage.fcmToken)
        self.requestLogin(login: loginDTO)
    }
}
