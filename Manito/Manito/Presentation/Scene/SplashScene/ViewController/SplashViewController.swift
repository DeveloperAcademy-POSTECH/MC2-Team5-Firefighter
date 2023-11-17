//
//  SplashViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import Combine
import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - ui component
    
    private let splashView: SplashView = SplashView()
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()

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

    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.splashView
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

    private func transformedOutput() -> SplashViewModel.Output? {
        guard let viewModel = self.viewModel as? SplashViewModel else { return nil }
        let input = SplashViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher
        )
        return viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: SplashViewModel.Output?) {
        guard let output else { return }

        output.entryType
            .sink(receiveValue: { [weak self] type in
                switch type {
                case .login: self?.presentLoginViewConroller()
                case .nickname: self?.presentCreateNicknameViewController()
                case .main: self?.presentMainViewController()
                }
            })
            .store(in: &self.cancelBag)
    }
}

// MARK: - Helper
extension SplashViewController {
    private func presentLoginViewConroller() {
        let viewController = LoginViewController()
        let navigtionViewController = UINavigationController(rootViewController: viewController)
        navigtionViewController.setNavigationBarHidden(true, animated: true)
        navigtionViewController.modalPresentationStyle = .fullScreen
        navigtionViewController.modalTransitionStyle = .crossDissolve
        self.present(navigtionViewController, animated: true)
    }

    private func presentCreateNicknameViewController() {
        let nicknameUsecase = NicknameUsecaseImpl(repository: SettingRepositoryImpl())
        let textFieldUsecase = TextFieldUsecaseImpl()
        let viewModel = NicknameViewModel(nicknameUsecase: nicknameUsecase,
                                          textFieldUsecase: textFieldUsecase)
        let viewController = CreateNicknameViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }

    private func presentMainViewController() {
        let navigationController = UINavigationController(rootViewController: MainViewController())
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        self.present(navigationController, animated: true)
    }
}
