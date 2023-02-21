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
    
    @IBOutlet weak var gifImageView: GIFImageView!
    
    // MARK: - property
    
    private let isLogin: Bool = UserDefaultStorage.isLogin
    private let nickname: String? = UserDefaultStorage.nickname
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - override

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.setupGifImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let isSetFcmToken = UserDefaultStorage.isSetFcmToken
            if !isSetFcmToken {
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
    
    // MARK: - func
    
    private func configUI() {
        self.view.backgroundColor = .backgroundGrey
    }

    private func presentLoginViewConroller() {
        let viewController = LoginViewController()
        let navigtionViewController = UINavigationController(rootViewController: viewController)
        navigtionViewController.setNavigationBarHidden(true, animated: true)
        navigtionViewController.modalPresentationStyle = .fullScreen
        navigtionViewController.modalTransitionStyle = .crossDissolve
        self.present(navigtionViewController, animated: true)
    }

    private func presentNicknameSettingViewController() {
        let viewController = CreateNickNameViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }

    private func presentMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }

    private func setupGifImage() {
        DispatchQueue.main.async {
            self.gifImageView.animate(withGIFNamed: ImageLiterals.gifLogo)
        }
    }
}
