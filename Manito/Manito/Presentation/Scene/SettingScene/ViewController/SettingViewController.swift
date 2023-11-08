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
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let withdrawalPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    private let logoutPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
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
        self.setupMailManager()
        self.bindViewModel()
        self.bindUI()
        self.setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    // MARK: - func
    
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
    
    private func transformedOutput() -> SettingViewModel.Output? {
        guard let viewModel = self.viewModel as? SettingViewModel else { return nil }
        let input = SettingViewModel.Input(logoutButtonDidTap: self.logoutPublisher.eraseToAnyPublisher(),
                                           withdrawalButtonDidTap: self.withdrawalPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SettingViewModel.Output?) {
        guard let output else { return }
        
        output.logout
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.logout()
            }
            .store(in: &self.cancellable)
        
        output.deleteUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(): self?.deleteUser()
                case .failure(let error): self?.makeAlert(title: error.localizedDescription)
                }
            }
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.settingView.buttonDidTapPublisher
            .sink { [weak self] type in
                switch type {
                case .changeNickname:
                    self?.pushChangeNicknameViewController()
                case .personInfomation:
                    self?.openUrlBySettingButton(type: .personInfomation)
                case .termsOfService:
                    self?.openUrlBySettingButton(type: .termsOfService)
                case .developerInfo:
                    self?.pushDeveloperInfoViewController()
                case .help:
                    self?.sendReportMail()
                case .logout:
                    self?.makeAlertBySettingButton(type: .logout)
                case .withdrawal:
                    self?.makeAlertBySettingButton(type: .withdrawal)
                }
            }
            .store(in: &self.cancellable)
    }
    
    private func makeAlertBySettingButton(type: SettingView.SettingActions) {
        switch type {
        case .logout:
            self.makeRequestAlert(title: TextLiteral.Setting.logoutAlertTitle.localized(),
                                   message: "",
                                   okAction: { [weak self] _ in
                self?.logoutPublisher.send()
            })
        case .withdrawal:
            self.makeRequestAlert(title: TextLiteral.Common.warningTitle.localized(),
                                   message: TextLiteral.Setting.withdrawalAlertMessage.localized(),
                                   okAction: { [weak self] _ in
                self?.withdrawalPublisher.send()
            })
        default: return
        }
    }
    
    private func openUrlBySettingButton(type: SettingView.SettingActions) {
        switch type {
        case .personInfomation: self.openUrl(url: URLLiteral.Setting.personalInformation)
        case .termsOfService: self.openUrl(url: URLLiteral.Setting.termsOfService)
        default: return
        }
    }
    
    private func sendReportMail() {
        let title = TextLiteral.Mail.inquiryTitle.localized()
        let content = TextLiteral.Mail.inquiryMessage.localized(with: UserDefaultStorage.nickname, Date().description)
        self.mailManager.sendMail(title: title, content: content)
    }
}

// MARK: - Helper

extension SettingViewController {
    private func pushChangeNicknameViewController() {
        self.navigationController?.pushViewController(ChangeNicknameViewController(viewModel: NicknameViewModel(nicknameService: NicknameService(repository: SettingRepositoryImpl()))), animated: true)
    }
    
    private func pushDeveloperInfoViewController() {
        self.navigationController?.pushViewController(SettingDeveloperInfoViewController(), animated: true)
    }
    
    private func deleteUser() {
        guard let sceneDelgate = UIApplication.shared.connectedScenes.first?.delegate
                as? SceneDelegate else { return }
        sceneDelgate.moveToLoginViewController()
    }
    
    private func logout() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                as? SceneDelegate else { return }
        sceneDelegate.moveToLoginViewController()
    }
    
    private func openUrl(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
