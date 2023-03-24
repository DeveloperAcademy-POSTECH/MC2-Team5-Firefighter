//
//  LoginViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/07.
//

import AuthenticationServices
import UIKit

import SnapKit

final class LoginViewController: BaseViewController {

    // MARK: - ui component

    private let logoImageView: UIImageView = UIImageView(image: ImageLiterals.imgAppIcon)
    private let logoTextImageView: UIImageView = UIImageView(image: ImageLiterals.imgTextLogo)
    private let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.cornerRadius = 25
        return button
    }()
    
    // MARK: - property
    
    private let loginService: LoginAPI = LoginAPI(apiService: APIService())
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoginButton()
    }

    // MARK: - override
    
    override func setupLayout() {
        self.view.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-92)
            $0.width.height.equalTo(130)
        }

        self.view.addSubview(self.logoTextImageView)
        self.logoTextImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.logoImageView.snp.bottom).offset(7)
        }

        self.view.addSubview(self.appleLoginButton)
        self.appleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(65)
            $0.height.equalTo(50)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(35)
        }
    }
    
    // MARK: - func
    
    private func setupLoginButton() {
        let action = UIAction { [weak self] _ in
            self?.appleSignIn()
        }
        self.appleLoginButton.addAction(action, for: .touchUpInside)
    }

    private func appleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    guard let token = appleIDCredential.identityToken else { return }
                    guard let tokenToString = String(data: token, encoding: .utf8) else { return }
                    
                    Task {
                        do {
                            let response = try await self.loginService.dispatchAppleLogin(dto: LoginDTO(identityToken: tokenToString, fcmToken: UserDefaultStorage.fcmToken))
                            
                            if let data = response {
                                UserDefaultHandler.setIsLogin(isLogin: true)
                                UserDefaultHandler.setAccessToken(accessToken: data.accessToken ?? "")
                                UserDefaultHandler.setRefreshToken(refreshToken: data.refreshToken ?? "")

                                guard data.nickname != nil else {
                                    self.navigationController?.pushViewController(CreateNickNameViewController(), animated: true)
                                    return
                                }
                                
                                UserDefaultHandler.setNickname(nickname: data.nickname ?? "")
                                UserDefaultHandler.setIsSetFcmToken(isSetFcmToken: true)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
                                viewController.modalPresentationStyle = .fullScreen
                                viewController.modalTransitionStyle = .crossDissolve
                                self.present(viewController, animated: true)
                            }
                        } catch NetworkError.serverError {
                            print("server Error")
                        } catch NetworkError.encodingError {
                            print("encoding Error")
                        } catch NetworkError.clientError(let message) {
                            print("client Error: \(String(describing: message))")
                        }
                    }
                    print("userIdentifier = \(userIdentifier)")
                    UserDefaultHandler.setUserID(userID: userIdentifier)
                    break
                default:
                    break
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.view.window else { return ASPresentationAnchor() }
        return window
    }
}
