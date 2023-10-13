//
//  SplashViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import Gifu

final class SplashViewController: UIViewController {
    
    // MARK: - ui component
    
    private let splashView: SplashView = SplashView()
    
    // MARK: - property
    
    private let isLogin: Bool = UserDefaultStorage.isLogin
    private let nickname: String? = UserDefaultStorage.nickname
    private let isSetFcmToken: Bool = UserDefaultStorage.isSetFcmToken

    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.splashView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentViewControllerAfterDelay()
    }

    // MARK: - func

    private func presentLoginViewConroller() {
        let viewController = LoginViewController()
        let navigtionViewController = UINavigationController(rootViewController: viewController)
        navigtionViewController.setNavigationBarHidden(true, animated: true)
        navigtionViewController.modalPresentationStyle = .fullScreen
        navigtionViewController.modalTransitionStyle = .crossDissolve
        self.present(navigtionViewController, animated: true)
    }

    private func presentNicknameSettingViewController() {
        let viewController = CreateNicknameViewController(viewModel: NicknameViewModel(nicknameService: NicknameService(repository: SettingRepositoryImpl())))
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }

    private func presentMainViewController() {
        let navigationController = UINavigationController(rootViewController: MainViewController())
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true)
    }
    
    private func presentViewControllerAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if !self.isSetFcmToken {
                self.presentLoginViewConroller()
            } else if self.isLogin {
                self.presentMainViewController()
            } else if self.isLogin && self.nickname == "" {
                self.presentNicknameSettingViewController()
            } else {
                self.presentLoginViewConroller()
            }
        }
    }
}
