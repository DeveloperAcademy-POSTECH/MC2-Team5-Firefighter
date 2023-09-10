//
//  SplashViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import Gifu
import MTResource

final class SplashViewController: UIViewController, BaseViewControllerType {
    
    // MARK: - ui component
    
    @IBOutlet weak var gifImageView: GIFImageView!
    
    // MARK: - property
    
    private let isLogin: Bool = UserDefaultStorage.isLogin
    private let nickname: String? = UserDefaultStorage.nickname
    private let isSetFcmToken: Bool = UserDefaultStorage.isSetFcmToken
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()
        self.setupGifImage()
        self.presentViewControllerAfterDelay()
    }
    
    // MARK: - base func

    func setupLayout() {
        // FIXME: - 스토리보드를 코드 베이스로 바꿔야 하는 화면입니다.
    }
    
    func configureUI() {
        self.view.backgroundColor = .backgroundGrey
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

    private func setupGifImage() {
        DispatchQueue.main.async {
            self.gifImageView.animate(withGIFNamed: GIFSet.logo)
        }
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
