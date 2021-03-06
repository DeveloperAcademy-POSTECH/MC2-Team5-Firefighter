//
//  LoginViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/07.
//

import AuthenticationServices
import UIKit

import SnapKit

class LoginViewController: BaseViewController {

    // MARK: - property

    private let logoImageView = UIImageView(image: ImageLiterals.imgAppIcon)
    private let logoTextImageView = UIImageView(image: ImageLiterals.imgTextLogo)
    private let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.cornerRadius = 25
        return button
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

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
}
