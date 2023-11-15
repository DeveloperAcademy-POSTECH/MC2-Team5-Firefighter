//
//  ParticipateRoomViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/06/15.
//

import Combine
import UIKit

import SnapKit

final class ParticipateRoomViewController: UIViewController, Keyboardable {
    
    // MARK: - ui component
    
    private let participateRoomView: ParticipateRoomView = ParticipateRoomView()
    
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
        self.view = self.participateRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigation()
        self.bindToViewModel()
        self.bindUI()
        self.setupKeyboardGesture()
    }
    
    // MARK: - override
    
    override func endEditingView() {
        self.participateRoomView.endEditing()
    }
    
    // MARK: - func
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.participateRoomView.configureNavigationBarItem(navigationController)
    }
    
    private func bindToViewModel() {
        let output = self.transfromedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transfromedOutput() -> ParticipateRoomViewModel.Output? {
        guard let viewModel = self.viewModel as? ParticipateRoomViewModel else { return nil }
        let input = ParticipateRoomViewModel.Input(viewDidLoad: self.viewDidLoadPublisher,
                                                   textFieldDidChanged: self.participateRoomView.textFieldDidChangedPublisher.eraseToAnyPublisher(),
                                                   nextButtonDidTap: self.participateRoomView.nextButtonTapPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: ParticipateRoomViewModel.Output?) {
        guard let output else { return }
        
        output.counts
            .sink(receiveValue: { [weak self] (textCount, maxCount) in
                self?.participateRoomView.updateTextCount(count: textCount, maxLength: maxCount)
            })
            .store(in: &self.cancellable)
        
        output.fixedTitleByMaxCount
            .sink { [weak self] fixedTitle in
                self?.participateRoomView.updateTextFieldText(fixedText: fixedTitle)
            }
            .store(in: &self.cancellable)
        
        output.isEnabled
            .sink(receiveValue: { [weak self] isEnable in
                self?.participateRoomView.toggleDoneButton(isEnabled: isEnable)
            })
            .store(in: &self.cancellable)
        
        output.roomInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let roomInfo):
                    self?.presentParticipationRoomDetailsView(roomInfo: roomInfo)
                case .failure(let error):
                    self?.makeAlert(title: error.localizedDescription)
                }
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.participateRoomView.closeButtonTapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &self.cancellable)
    }
}

// MARK: - Helper

extension ParticipateRoomViewController {
    private func presentParticipationRoomDetailsView(roomInfo: ParticipatedRoomInfo) {
        let viewController = ParticipationRoomDetailsViewController(viewModel: ParticipationRoomDetailsViewModel(roomInfo: roomInfo))
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
}
