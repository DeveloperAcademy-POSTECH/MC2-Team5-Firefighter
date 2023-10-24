//
//  LoginView.swift
//  Manito
//
//  Created by COBY_PRO on 10/24/23.
//

import AuthenticationServices
import Combine
import UIKit

import SnapKit

protocol LoginViewDelegate: AnyObject {
    func didTapCloseButton()
}

final class LoginView: UIView, BaseViewType {
    
    // MARK: - ui component

    private let logoImageView: UIImageView = UIImageView(image: UIImage.Image.appIcon)
    private let logoTextImageView: UIImageView = UIImageView(image: UIImage.Image.textLogo)
    private let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.cornerRadius = 25
        return button
    }()
    
    // MARK: - property
    
    private weak var delegate: LoginViewDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-92)
            $0.width.height.equalTo(130)
        }

        self.addSubview(self.logoTextImageView)
        self.logoTextImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.logoImageView.snp.bottom).offset(7)
        }

        self.addSubview(self.appleLoginButton)
        self.appleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(65)
            $0.height.equalTo(50)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(35)
        }
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - func

    private func setupAction() {
    }
    
    func configureDelegate(_ delegate: LoginViewDelegate) {
        self.delegate = delegate
    }
}
