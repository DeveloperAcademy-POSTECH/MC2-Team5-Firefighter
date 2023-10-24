//
//  LoginViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/07/07.
//

import AuthenticationServices
import Combine
import UIKit

import SnapKit

final class LoginViewController: UIViewController, Navigationable {

    // MARK: - ui component

    private let loginView: LoginView = LoginView()
    
    // MARK: - property
    
    private var cancellable = Set<AnyCancellable>()
    private let loginViewModel: LoginViewModel
    
    // MARK: - init
    
    init(viewModel: LoginViewModel) {
        self.loginViewModel = viewModel
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
        self.setupNavigationBarHiddenState()
        self.bindViewModel()
        self.setupNavigation()
    }

    // MARK: - func

    private func setupNavigationBarHiddenState() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> LoginViewModel.Output {
        let input = LoginViewModel.Input(
            appleSignButtonDidTap: self.loginView.appleSignButtonDidTapPublisher.eraseToAnyPublisher()
        )
        return self.loginViewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: LoginViewModel.Output) {
        output.loginDTO
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    // FIXME: - 에러 코드 추가 작성 필요
                    self?.makeAlert(title: "에러발생")
                }
            }, receiveValue: { [weak self] loginDTO in
                UserDefaultHandler.setIsLogin(isLogin: true)
                UserDefaultHandler.setAccessToken(accessToken: loginDTO.accessToken ?? "")
                UserDefaultHandler.setRefreshToken(refreshToken: loginDTO.refreshToken ?? "")
                
                if let isNewMember = loginDTO.isNewMember {
                    if isNewMember {
                        self?.navigationController?.pushViewController(CreateNicknameViewController(viewModel: NicknameViewModel(nicknameService: NicknameService(repository: SettingRepositoryImpl()))), animated: true)
                        return
                    }
                }
                
                UserDefaultHandler.setNickname(nickname: loginDTO.nickname ?? "")
                UserDefaultHandler.setIsSetFcmToken(isSetFcmToken: true)
                
                self?.presentMainViewController()
            })
            .store(in: &self.cancellable)
    }
}

// MARK: - Helper
extension LoginViewController {
    private func presentMainViewController() {
        let navigationController = UINavigationController(rootViewController: MainViewController())
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true)
    }
}
