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
    
    private let viewModel: ChooseCharacterViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - init
    
    init(viewModel: ChooseCharacterViewModel) {
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
        let output = self.transfromedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transfromedOutput() -> ChooseCharacterViewModel.Output {
        let input = ChooseCharacterViewModel.Input(joinButtonTapPublisher: self.chooseCharacterView.joinButtonTapPublisher.eraseToAnyPublisher(),
                                                   characterIndexPublisher: self.chooseCharacterView.manittoCollectionView.characterIndexTapPublisher.eraseToAnyPublisher()
        )
        return self.viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: ChooseCharacterViewModel.Output) {
        output.roomId
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    return
                case .failure(let error):
                    switch error {
                    case .roomAlreadyParticipating: self?.makeAlertWhenAlreadyJoin(error: error.localizedDescription)
                    case .someError: self?.makeAlertWhenNetworkError(error: error.localizedDescription)
                    }
                    
                }
            } receiveValue: { self.pushDetailWaitViewController(roomId: $0) }
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.chooseCharacterView.backButtonTapPublisher
            .sink {
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &self.cancellable)
        
        self.chooseCharacterView.closeButtonTapPublisher
            .sink {
                self.dismiss(animated: true)
            }
            .store(in: &self.cancellable)
    }
    
    private func pushDetailWaitViewController(roomId: Int) {
        guard let navigationController = self.presentingViewController as? UINavigationController else { return }
        let viewModel = DetailWaitViewModel(roomIndex: roomId, detailWaitService: DetailWaitService(repository: DetailRoomRepositoryImpl()))
        let viewController = DetailWaitViewController(viewModel: viewModel)
        self.dismiss(animated: true) {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func makeAlertWhenAlreadyJoin(error: String) {
        self.makeAlert(title: error.description, message: "참여중인 애니또 리스트를 확인해 보세요", okAction: { [weak self] _ in
            self?.dismiss(animated: true)
        })
    }
    
    private func makeAlertWhenNetworkError(error: String) {
        self.makeAlert(title: error.description, message: "네트워크 확인 후 다시 시도해 보세요.", okAction: { [weak self] _ in
            self?.dismiss(animated: true)
        })
    }
}