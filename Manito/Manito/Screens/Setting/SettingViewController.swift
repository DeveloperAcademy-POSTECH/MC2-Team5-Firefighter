//
//  SettingViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import UIKit

import SnapKit

final class SettingViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let settingView: SettingView = SettingView()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.settingView.configureDelegate(self)
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}


// MARK: - Extensions

extension SettingViewController: SettingViewDelegate {
    func changNicknameButtonDidTap() {
        self.navigationController?.pushViewController(ChangeNickNameViewController(), animated: true)
    }
    
    func personalInfomationButtonDidTap() {
        if let url = URL(string: URLLiteral.personalInfomationUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func termsOfServiceButtonDidTap() {
        if let url = URL(string: URLLiteral.termsOfServiceUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func developerInfoButtonDidTap() {
        self.navigationController?.pushViewController(SettingDeveloperInfoViewController(), animated: true)
    }
    
    func helpButtonDidTap() {
        self.sendReportMail()
    }
    
    func logoutButtonDidTap() {
        self.makeRequestAlert(title: "로그아웃 하시겠습니까?", message: "", okTitle: "확인", cancelTitle: "취소", okAction: { _ in
            UserDefaultHandler.clearAllDataExcludingFcmToken()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                    as? SceneDelegate else { return }
            sceneDelegate.logout()
        })
    }
}


