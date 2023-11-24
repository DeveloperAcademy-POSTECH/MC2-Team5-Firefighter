//
//  ChooseRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/18.
//

import Combine
import UIKit

import SnapKit

final class ChooseCharacterViewController: UIViewController, Navigationable {
    
    // MARK: - ui component

    private let chooseCharacterView: ChooseCharacterView = ChooseCharacterView()
    
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
        self.view = self.chooseCharacterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
        self.setupNavigation()
        self.bindToViewModel()
        self.bindUI()
    }
    
    // MARK: - func
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.chooseCharacterView.configureNavigationBarItem(navigationController)
    }
    
    private func bindToViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> ChooseCharacterViewModel.Output? {
        guard let viewModel = self.viewModel as? ChooseCharacterViewModel else { return nil }
        let input = ChooseCharacterViewModel.Input(joinButtonTapPublisher: self.chooseCharacterView.joinButtonTapPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: ChooseCharacterViewModel.Output?) {
        guard let output else { return }
        
        output.roomId
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let roomId):
                    self?.pushDetailWaitViewController(roomId: roomId)
                case .failure(let error):
                    switch error {
                    case .roomAlreadyParticipating: self?.makeAlertWhenAlreadyJoin(error: error.localizedDescription)
                    default: self?.makeAlertWhenNetworkError(error: error.localizedDescription)
                    }
                }
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.chooseCharacterView.backButtonTapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellable)
        
        self.chooseCharacterView.closeButtonTapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &self.cancellable)
    }
    
    private func makeAlertWhenAlreadyJoin(error: String) {
        self.makeAlert(title: TextLiteral.ParticipateRoom.Error.alreadyJoinTitle.localized(), 
                       message: error,
                       okAction: { [weak self] _ in
            self?.dismiss(animated: true)
        })
    }
    
    private func makeAlertWhenNetworkError(error: String) {
        self.makeAlert(title: TextLiteral.Common.Error.title.localized(), 
                       message: error,
                       okAction: nil)
    }
}

// MARK: - Helper

extension ChooseCharacterViewController {
    private func pushDetailWaitViewController(roomId: Int) {
        guard let navigationController = self.presentingViewController as? UINavigationController else { return }
        let repository = DetailRoomRepositoryImpl()
        let usecase = DetailWaitUseCaseImpl(repository: repository)
        let viewModel = DetailWaitViewModel(roomId: roomId.description, usecase: usecase)
        let viewController = DetailWaitViewController(viewModel: viewModel)
        self.dismiss(animated: true) {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
