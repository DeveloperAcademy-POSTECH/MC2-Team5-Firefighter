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
                    self?.makeAlert(title: TextLiteral.fail, message: TextLiteral.settingViewControllerFailMessage)
                }
            } receiveValue: { [weak self] _ in
                self?.makeRequestAlert(title: TextLiteral.alert,
                                       message: TextLiteral.settingViewControllerWithdrawalMessage,
                                       okAction: { [weak self] _ in
                    self?.deleteUser()
                })
            }
            .store(in: &self.cancellable)
        
        output.logout
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.makeRequestAlert(title: TextLiteral.settingViewControllerLogoutAlertTitle,
                                       message: "",
                                       okAction: { [weak self] _ in
                    self?.logout()
                })
            }
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.settingView.changNicknameButtonDidTapPublisher
            .sink { [weak self] _ in
                self?.changNicknameButtonDidTap()
            }
            .store(in: &self.cancellable)
        
        self.settingView.personalInfomationButtonDidTapPublisher
            .sink { [weak self] _ in
                self?.personalInfomationButtonDidTap()
            }
            .store(in: &self.cancellable)
        
        self.settingView.termsOfServiceButtonDidTapPublisher
            .sink { [weak self] _ in
                self?.termsOfServiceButtonDidTap()
            }
            .store(in: &self.cancellable)
        
        self.settingView.developerInfoButtonDidTapPublisher
            .sink { [weak self] _ in
                self?.developerInfoButtonDidTap()
            }
            .store(in: &self.cancellable)
        
        self.settingView.helpButtonDidTapPublisher
            .sink { [weak self] _ in
                self?.helpButtonDidTap()
            }
            .store(in: &self.cancellable)
    }
    
    private func changNicknameButtonDidTap() {
        self.navigationController?.pushViewController(ChangeNicknameViewController(viewModel: NicknameViewModel(nicknameService: NicknameService(repository: SettingRepositoryImpl()))), animated: true)
    }
    
    private func personalInfomationButtonDidTap() {
        if let url = URL(string: URLLiteral.personalInfomationUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func termsOfServiceButtonDidTap() {
        if let url = URL(string: URLLiteral.termsOfServiceUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func developerInfoButtonDidTap() {
        self.navigationController?.pushViewController(SettingDeveloperInfoViewController(), animated: true)
    }
    
    private func helpButtonDidTap() {
        self.sendReportMail()
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