//
//  SplashViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import Gifu

final class SplashViewController: BaseViewController {

    let isLogin = UserData<String>.getValue(forKey: .accessToken)
    let nickname = UserData<String>.getValue(forKey: .nickname)

    // MARK: - property

    @IBOutlet weak var gifImageView: GIFImageView!

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGifImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.isLogin == nil {
                self.presentLoginViewConroller()
            } else if self.isLogin != nil && self.nickname == nil {
                self.presentNicknameSettingViewController()
            } else {
                self.presentMainViewController()
            }
        }
    }

    // MARK: - func
    
    private func presentLoginViewConroller() {
        let viewController = LoginViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
    
    private func presentNicknameSettingViewController() {
        let viewController = CreateNickNameViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }

    private func presentMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true, completion: nil)
    }
    
    private func setupGifImage() {
        DispatchQueue.main.async {
            self.gifImageView.animate(withGIFNamed: ImageLiterals.gifLogo, animationBlock: nil)
        }
    }
}
