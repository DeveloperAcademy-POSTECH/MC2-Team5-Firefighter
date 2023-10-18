//
//  SettingViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import Combine
import UIKit

import SnapKit

final class SettingViewController: UIViewController, Navigationable {
    
    // MARK: - ui component
    
    private let settingView: SettingView = SettingView()
    
    // MARK: - property
    
    private let mailManager: MailComposeManager = MailComposeManager()
    
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: SettingViewModel
    
    // MARK: - init
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.setupMailManager()
        self.bindViewModel()
        self.setupNavigation()
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
    
    private func setupMailManager() {
        self.mailManager.viewController = self
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> SettingViewModel.Output {
        let input = SettingViewModel.Input(withdrawalButtonDidTap: self.settingView.withdrawalButtonPublisher.eraseToAnyPublisher(),
                                           logoutButtonDidTap: self.settingView.logoutButtonPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SettingViewModel.Output) {
        output.deleteUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                                    message: TextLiteral.Setting.Error.withDrawalMessage.localized())
                }
            } receiveValue: { [weak self] _ in
                self?.deleteUser()
            }
            .store(in: &self.cancellable)
        
        output.logout
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.logout()
            }
            .store(in: &self.cancellable)
    }
    
    private func deleteUser() {
        UserDefaultHandler.clearAllDataExcludingFcmToken()
        
        guard let sceneDelgate = UIApplication.shared.connectedScenes.first?.delegate
                as? SceneDelegate else { return }
        sceneDelgate.moveToLoginViewController()
    }
    
    private func logout() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                as? SceneDelegate else { return }
        sceneDelegate.moveToLoginViewController()
    }
}

// MARK: - Extensions

extension SettingViewController: SettingViewDelegate {
    func changNicknameButtonDidTap() {
        self.navigationController?.pushViewController(ChangeNicknameViewController(viewModel: NicknameViewModel(nicknameService: NicknameService(repository: SettingRepositoryImpl()))), animated: true)
    }
    
    func personalInfomationButtonDidTap() {
        if let url = URL(string: URLLiteral.Setting.personalInformation) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func termsOfServiceButtonDidTap() {
        if let url = URL(string: URLLiteral.Setting.termsOfService) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func developerInfoButtonDidTap() {
        self.navigationController?.pushViewController(SettingDeveloperInfoViewController(), animated: true)
    }
    
    func helpButtonDidTap() {
        let title = TextLiteral.Mail.inquiryTitle.localized()
        let content = TextLiteral.Mail.inquiryMessage.localized(with: UserDefaultStorage.nickname, Date().description)
        self.mailManager.sendMail(title: title, content: content)
    }
    
    func logoutButtonDidTap() {
        self.makeRequestAlert(title: TextLiteral.Setting.logoutAlertTitle.localized(),
                              message: "",
                              okTitle: TextLiteral.Common.confirm.localized(),
                              cancelTitle: TextLiteral.Common.cancel.localized(),
                              okAction: { [weak self] _ in
            self?.settingView.logoutButtonPublisher.send()
        })
    }
    
    func withdrawalButtonDidTap() {
        self.makeRequestAlert(title: TextLiteral.Common.warningTitle.localized(),
                              message: TextLiteral.Setting.withdrawalAlertMessage.localized(),
                              okTitle: TextLiteral.Setting.withdrawalAlertOk.localized(),
                              okAction: { [weak self] _ in
            self?.settingView.withdrawalButtonPublisher.send()
        })
    }
}
