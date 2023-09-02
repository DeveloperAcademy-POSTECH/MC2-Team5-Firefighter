//
//  SettingViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import Combine
import UIKit

import SnapKit

final class SettingViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let settingView: SettingView = SettingView()
    
    // MARK: - property
    
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: SettingViewModel
    
    // MARK: - init
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init()
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
        self.bindViewModel()
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
        self.makeRequestAlert(title: TextLiteral.settingViewControllerLogoutAlertTitle, message: "", okTitle: TextLiteral.confirm, cancelTitle: TextLiteral.cancel, okAction: { [weak self] _ in
            self?.settingView.logoutButtonPublisher.send()
        })
    }
    
    func withdrawalButtonDidTap() {
        self.makeRequestAlert(title: TextLiteral.alert, message: TextLiteral.settingViewControllerWithdrawalMessage, okTitle: TextLiteral.settingViewControllerWithdrawal) { [weak self] _ in
            self?.settingView.withdrawalButtonPublisher.send()
        }
    }
}
