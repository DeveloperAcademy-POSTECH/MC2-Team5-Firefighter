//
//  ChangeNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/09/05.
//

import Combine
import UIKit

import SnapKit

class ChangeNickNameViewController: BaseViewController {
    
    // MARK: - property
    
    private let viewModel: NicknameViewModel
    private lazy var nicknameView: NicknameView = NicknameView(title: TextLiteral.changeNickNameViewControllerTitle)
    
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - init
    
    init(viewModel: NicknameViewModel) {
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
        self.view = self.nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
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
    
    private func transformedOutput() -> NicknameViewModel.Output {
        let input = NicknameViewModel.Input(viewDidLoad: self.viewDidLoadPublisher,
                                            textFieldDidChanged: self.nicknameView.textFieldPublisher.eraseToAnyPublisher(),
                                            doneButtonDidTap: self.nicknameView.doneButtonTapPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: NicknameViewModel.Output) {
        output.nickname
            .sink { [weak self] nickname in
                self?.nicknameView.setupNickname(nickname: nickname)
            }
            .store(in: &self.cancellable)
        
        output.title
            .sink { [weak self] text in
                self?.nicknameView.updateTextCount(count: text.count, maxLength: self?.viewModel.maxCount ?? 0)
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
                    self?.makeAlert(title: TextLiteral.fail, message: "실패")
                }
            } receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellable)
    }
}
