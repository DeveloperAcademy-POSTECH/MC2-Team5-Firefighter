//
//  CreateNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/12.
//

import Combine
import UIKit

import SnapKit

final class CreateNicknameViewController: BaseViewController {
    
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
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationController()
        self.setupBackButton()
        self.bindViewModel()
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
    
    override func removeBarButtonItemOffset(with view: UIView, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(view)
        return offsetView
    }
    
    // MARK: - func
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.nicknameView.configureNavigationItem(navigationController)
    }
    
    private func setupBackButton() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: UIView(), offsetX: 10)
        let emptyView = makeBarButtonItem(with: leftOffsetBackButton)

        navigationItem.leftBarButtonItem = emptyView
    }
    
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
        output.nicknameMaxCount
            .sink { [weak self] nicknameMaxCount in
                self?.nicknameView.updateTextCount(count: 0, maxLength: nicknameMaxCount.maxCount)
            }
            .store(in: &self.cancellable)
        
        output.counts
            .sink { [weak self] counts in
                self?.nicknameView.updateTextCount(count: counts.textCount, maxLength: counts.maxCount)
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
