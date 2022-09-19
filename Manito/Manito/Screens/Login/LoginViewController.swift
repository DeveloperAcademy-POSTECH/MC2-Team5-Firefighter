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
    let loginService: LoginAPI = LoginAPI(apiService: APIService())

    // MARK: - property

    private let logoImageView = UIImageView(image: ImageLiterals.imgAppIcon)
    private let logoTextImageView = UIImageView(image: ImageLiterals.imgTextLogo)
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        let action = UIAction { [weak self] _ in
            self?.appleSignIn()
        }
        button.cornerRadius = 25
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - func

    override func render() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-92)
            $0.width.height.equalTo(130)
        }

        view.addSubview(logoTextImageView)
        logoTextImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(7)
        }

        appleLoginButton.layer.cornerRadius = 25
        view.addSubview(appleLoginButton)
        appleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(65)
            $0.height.equalTo(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(35)
        }
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
                    // The Apple ID credential is valid. Show Home UI Here
                    guard let token = appleIDCredential.identityToken else { return }
                    guard let tokenToString = String(data: token, encoding: .utf8) else { return }
                    
                    Task {
                        do {
                            let response = try await self.loginService.dispatchAppleLogin(dto: LoginDTO(identityToken: tokenToString))
                            
                            if let data = response {
                                UserDefaultHandler.setIsLogin(isLogin: true)
                                UserDefaultHandler.setAccessToken(accessToken: data.accessToken ?? "")
                                UserDefaultHandler.setRefreshToken(refreshToken: data.refreshToken ?? "")

                                guard data.nickname != nil else {
                                    UserDefaultHandler.setNickname(nickname: data.nickname ?? "")
                                    self.navigationController?.pushViewController(CreateNickNameViewController(), animated: true)
                                    return
                                }
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
                                viewController.modalPresentationStyle = .fullScreen
                                viewController.modalTransitionStyle = .crossDissolve
                                self.present(viewController, animated: true, completion: nil)
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
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
                    break
                case .notFound:
                    // No credential was found. Show SignIn UI Here.
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
        return view.window!
    }
}
