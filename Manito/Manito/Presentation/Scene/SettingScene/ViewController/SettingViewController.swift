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
    private let withdrawalPublisher = PassthroughSubject<Void, Never>()
    private let logoutPublisher = PassthroughSubject<Void, Never>()
    
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
        let input = SettingViewModel.Input(logoutButtonDidTap: self.logoutPublisher.eraseToAnyPublisher(),
                                           withdrawalButtonDidTap: self.withdrawalPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SettingViewModel.Output) {
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
                case .finished: return
                case .failure(_):
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                                    message: TextLiteral.Setting.Error.withDrawalMessage.localized())
                }
            } receiveValue: { [weak self] _ in
                self?.deleteUser()
            }
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.settingView.buttonDidTapPublisher
            .sink { [weak self] type in
                switch type {
                case .changeNickname:
                    self?.changNicknameButtonDidTap()
                case .personInfomation:
                    self?.personalInfomationButtonDidTap()
                case .termsOfService:
                    self?.termsOfServiceButtonDidTap()
                case .developerInfo:
                    self?.developerInfoButtonDidTap()
                case .help:
                    self?.helpButtonDidTap()
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
        default:
            return
        }
    }
    
    private func changNicknameButtonDidTap() {
        self.navigationController?.pushViewController(ChangeNicknameViewController(viewModel: NicknameViewModel(nicknameService: NicknameService(repository: SettingRepositoryImpl()))), animated: true)
    }
    
    private func personalInfomationButtonDidTap() {
        if let url = URL(string: URLLiteral.Setting.personalInformation) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func termsOfServiceButtonDidTap() {
        if let url = URL(string: URLLiteral.Setting.termsOfService) {
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
