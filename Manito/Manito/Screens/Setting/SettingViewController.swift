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
    
    private let settingService: SettingAPI = SettingAPI(apiService: APIService())
    
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
    
    private func requestDeleteMember(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await settingService.deleteMember()
                switch statusCode {
                case 200..<300: completionHandler(.success(()))
                default:
                    print(statusCode)
                    completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
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
    
    func withdrawalButtonDidTap() {
        self.requestDeleteMember() { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure:
                print("error")
            }
        }
    }
}
