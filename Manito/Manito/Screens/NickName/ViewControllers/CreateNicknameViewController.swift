//
//  CreateNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/12.
//

import Combine
import UIKit

import SnapKit

final class CreateNicknameViewController: UIViewController, Keyboardable {
    
    // MARK: - ui component
    
    private let nicknameView: NicknameView = NicknameView(title: TextLiteral.Nickname.createTitle.localized())
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
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
        self.view = self.nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationController()
        self.setupBackButton()
        self.bindViewModel()
        self.setupKeyboardGesture()
    }
    
    override func endEditingView() {
        self.nicknameView.endEditingView()
    }
    
    // MARK: - func
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.nicknameView.configureNavigationItem(navigationController)
    }
    
    private func setupBackButton() {
        let leftOffsetBackButton = removeItemOffset(with: UIView(), offsetX: 10)
        let emptyView = makeBarButtonItem(with: leftOffsetBackButton)

        navigationItem.leftBarButtonItem = emptyView
    }
    
    private func removeItemOffset(with view: UIView, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(view)
        return offsetView
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> NicknameViewModel.Output? {
        guard let viewModel = self.viewModel as? NicknameViewModel else { return nil }
        let input = NicknameViewModel.Input(viewDidLoad: self.viewDidLoadPublisher,
                                            textFieldDidChanged: self.nicknameView.textFieldPublisher.eraseToAnyPublisher(),
                                            doneButtonDidTap: self.nicknameView.doneButtonTapPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: NicknameViewModel.Output?) {
        guard let output else { return }
        
        output.counts
            .sink { [weak self] (textCount, maxCount) in
                self?.nicknameView.updateTextCount(count: textCount, maxLength: maxCount)
            }
            .store(in: &self.cancellable)
        
        output.fixedTitleByMaxCount
            .sink { [weak self] fixedTitle in
                self?.nicknameView.updateTextFieldText(fixedText: fixedTitle)
            }
            .store(in: &self.cancellable)
        
        output.isEnabled
            .sink { [weak self] isEnabled in
                self?.nicknameView.toggleDoneButton(isEnabled: isEnabled)
            }
            .store(in: &self.cancellable)

        output.doneButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    // FIXME: - 일단 기본 에러로 설정해뒀습니다.
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                                    message: TextLiteral.Common.Error.networkServer.localized())
                }
            } receiveValue: { [weak self] _ in
                self?.presentMainViewController()
            }
            .store(in: &self.cancellable)
    }
}

// MARK: - Helper

extension CreateNicknameViewController {
    private func presentMainViewController() {
        let viewController = MainViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
}
