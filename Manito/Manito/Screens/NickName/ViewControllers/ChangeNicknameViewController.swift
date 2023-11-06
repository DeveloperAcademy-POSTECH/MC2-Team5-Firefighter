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
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    private lazy var nicknameView: NicknameView = NicknameView(title: TextLiteral.Nickname.changeTitle.localized())
    
    private var cancellable = Set<AnyCancellable>()
    
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
                case .finished: return
                case .failure(_):
                    // FIXME: - Common 에러로 일단 설정했습니다.
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                                    message: TextLiteral.Common.Error.networkServer.localized())
                }
            } receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellable)
    }
}
