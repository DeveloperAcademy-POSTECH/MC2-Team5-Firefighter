//
//  ChangeNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/09/05.
//

import Combine
import UIKit

import SnapKit

final class ChangeNicknameViewController: UIViewController, Navigationable, Keyboardable {
    
    // MARK: - ui component
    
    private let nicknameView: NicknameView = NicknameView(title: TextLiteral.Nickname.changeTitle.localized())
    
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
        self.bindViewModel()
        self.setupNavigation()
        self.setupKeyboardGesture()
    }
    
    // MARK: - override
    
    override func endEditingView() {
        self.nicknameView.endEditingView()
    }

    // MARK: - func
    
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
        
        output.nickname
            .sink { [weak self] nickname in
                self?.nicknameView.updateNickname(nickname: nickname)
            }
            .store(in: &self.cancellable)
        
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
                case .success(): self?.popViewController()
                case .failure(let error): self?.makeAlert(title: error.localizedDescription)
                }
            }
            .store(in: &self.cancellable)
    }
}

// MARK: - Helper

extension ChangeNicknameViewController {
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
