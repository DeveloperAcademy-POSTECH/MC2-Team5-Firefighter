//
//  LoginViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/07.
//

import Combine
import UIKit

import SnapKit

final class LoginViewController: UIViewController {

    // MARK: - ui component

    private let loginView: LoginView = LoginView()
    
    // MARK: - property
    
    private var cancellable: Set<AnyCancellable> = Set()
    private let viewModel: any BaseViewModelType
    
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
        self.view = self.loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }

    // MARK: - func
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> LoginViewModel.Output? {
        guard let viewModel = self.viewModel as? LoginViewModel else { return nil }
        let input = LoginViewModel.Input(
            appleSignButtonDidTap: self.loginView.appleSignButtonTapPublisher
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: LoginViewModel.Output?) {
        guard let output else { return }
        
        output.isNewLogin
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let isNewLogin):
                    if isNewLogin {
                        self?.presentCreateNicknameViewController()
                    } else {
                        self?.presentMainViewController()
                    }
                case .failure(let error):
                    switch error {
                    case .failedToLogin: self?.makeAlertWhenLoginError(error: error.localizedDescription)
                    case .failedCredential: self?.makeAlertWhenCredentialError(error: error.localizedDescription)
                    case .failedToken: self?.makeAlertWhenTokenError(error: error.localizedDescription)
                    case .failedTokenToString: self?.makeAlertWhenTokenToStringError(error: error.localizedDescription)
                    }
                }
            })
            .store(in: &self.cancellable)
    }
}

// MARK: - Helper
extension LoginViewController {
    private func presentCreateNicknameViewController() {
        let repository = SettingRepositoryImpl()
        let service = NicknameService(repository: repository)
        let viewModel = NicknameViewModel(nicknameService: service)
        let viewController = CreateNicknameViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentMainViewController() {
        let navigationController = UINavigationController(rootViewController: MainViewController())
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true)
    }
    
    private func makeAlertWhenLoginError(error: String) {
        self.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                       message: error)
    }
    
    private func makeAlertWhenCredentialError(error: String) {
        self.makeAlert(title: TextLiteral.Sign.Error.credential.localized(),
                       message: error)
    }
    
    private func makeAlertWhenTokenError(error: String) {
        self.makeAlert(title: TextLiteral.Sign.Error.token.localized(),
                       message: error)
    }
    
    private func makeAlertWhenTokenToStringError(error: String) {
        self.makeAlert(title: TextLiteral.Sign.Error.tokenToString.localized(),
                       message: error)
    }
}
