//
//  CreateNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/12.
//

import Combine
import UIKit

import SnapKit

class CreateNickNameViewController: BaseViewController {
    
    // MARK: - property
    
    private let viewModel: NicknameViewModel
    private lazy var nicknameView: NicknameView = NicknameView(title: TextLiteral.createNickNameViewControllerTitle)
    
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
    
    // MARK: - life Cycle
    
    override func loadView() {
        self.view = self.nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    // MARK: - override
    
    override func configureUI() {
        super.configureUI()
    }
    
    private func presentMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
    
    override func endEditingView() {
        self.nicknameView.endEditingView()
    }
    
    // MARK: - func
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> NicknameViewModel.Output {
        let input = NicknameViewModel.Input(textFieldDidChanged: self.nicknameView.textFieldPublisher.eraseToAnyPublisher(),
                                            doneButtonDidTap: self.nicknameView.doneButtonTapPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: NicknameViewModel.Output) {
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
                self?.presentMainViewController()
            }
            .store(in: &self.cancellable)
    }
}
