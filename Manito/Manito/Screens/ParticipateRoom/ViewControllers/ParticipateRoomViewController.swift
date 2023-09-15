//
//  ParticipateRoomViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/06/15.
//

import Combine
import UIKit

import SnapKit

final class ParticipateRoomViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let participateRoomView: ParticipateRoomView = ParticipateRoomView()
    
    // MARK: - property
    
    private let viewModel: ParticipateRoomViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - init
    
    init(viewModel: ParticipateRoomViewModel) {
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
        self.view = self.participateRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.configureNavigation()
        self.bindToViewModel()
    }
    
    // MARK: - override
    
    override func endEditingView() {
        self.participateRoomView.endEditing()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.participateRoomView.configureDelegate(self)
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.participateRoomView.configureNavigationBarItem(navigationController)
    }
    
    private func bindToViewModel() {
        let output = self.transfromedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transfromedOutput() -> ParticipateRoomViewModel.Output {
        let input = ParticipateRoomViewModel.Input(viewDidLoad: self.viewDidLoadPublisher,
                                                   textFieldDidChanged: self.participateRoomView.inputInvitedCodeView.textFieldDidChangedPublisher.eraseToAnyPublisher(),
                                                   nextButtonDidTap: self.participateRoomView.nextButtonTapPublisher.eraseToAnyPublisher())
        return self.viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: ParticipateRoomViewModel.Output) {
        output.counts
            .sink(receiveValue: { [weak self] (textCount, maxCount) in
                self?.participateRoomView.inputInvitedCodeView.updateTextCount(count: textCount, maxLength: maxCount)
            })
            .store(in: &self.cancellable)
        
        output.fixedTitleByMaxCount
            .sink { [weak self] fixedTitle in
                self?.participateRoomView.inputInvitedCodeView.updateTextFieldText(fixedText: fixedTitle)
            }
            .store(in: &self.cancellable)
        
        output.isEnabled
            .sink(receiveValue: { [weak self] isEnable in
                self?.participateRoomView.toggleDoneButton(isEnabled: isEnable)
            })
            .store(in: &self.cancellable)
        
        output.roomInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    self?.makeAlert(title: TextLiteral.participateRoomViewControllerInvalidCodeAlertErrorMessage)
                }
            } receiveValue: { [weak self] roomInfo in
                self?.presentParticipationRoomDetailsView(roomInfo: roomInfo)
            }
            .store(in: &self.cancellable)
    }
    
    private func presentParticipationRoomDetailsView(roomInfo: ParticipatedRoomInfo) {
        let viewController = ParticipationRoomDetailsViewController(viewModel: ParticipationRoomDetailsViewModel(roomInfo: roomInfo))
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
}

extension ParticipateRoomViewController: ParticipateRoomViewDelegate {
    func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
}
