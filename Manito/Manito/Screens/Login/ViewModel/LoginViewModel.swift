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
    
    private let loginService: LoginService
    private var cancellable = Set<AnyCancellable>()
    
    private let loginDTOSubject = PassthroughSubject<LoginDTO, NetworkError>()
    
    struct Input {
        let appleSignButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let loginDTO: PassthroughSubject<LoginDTO, NetworkError>
    }
    
    func transform(from input: Input) -> Output {
        input.appleSignButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.didTapAppleSignButton()
            })
            .store(in: &self.cancellable)
        return Output(loginDTO: self.loginDTOSubject)
    }
    
    // MARK: - init
    
    init(loginService: LoginService) {
        self.loginService = loginService
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
                let loginDTO = try await self.loginService.dispatchAppleLogin(login: login)
                self.loginDTOSubject.send(loginDTO)
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.loginDTOSubject.send(completion: .failure(error))
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
        requestLogin(login: loginDTO)
    }
}
