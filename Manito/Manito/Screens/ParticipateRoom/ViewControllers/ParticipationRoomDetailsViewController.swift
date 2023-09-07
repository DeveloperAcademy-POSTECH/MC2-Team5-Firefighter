//
//  ParticipationRoomDetailsViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/06/15.
//

import Combine
import UIKit

import SnapKit

final class ParticipationRoomDetailsViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let checkRoomView: ParticipationRoomDetails = ParticipationRoomDetails()
    
    // MARK: - property

    private let viewModel: ParticipationRoomDetailsViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - init
    
    init(viewModel: ParticipationRoomDetailsViewModel) {
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
        self.view = self.checkRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindToViewModel()
    }
    
    // MARK: - override
    
    override func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    // MARK: - func
    
    private func bindToViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> ParticipationRoomDetailsViewModel.Output {
        let input = ParticipationRoomDetailsViewModel.Input(viewDidLoad: self.viewDidLoadPublisher,
                                             yesButtonDidTap: self.checkRoomView.yesButtonDidTapPublisher)
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: ParticipationRoomDetailsViewModel.Output) {
        output.roomInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] roomInfo in
                self?.checkRoomView.updateRoomInfo(roomInfo: roomInfo)
            })
            .store(in: &self.cancellable)
        
        self.checkRoomView.noButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &self.cancellable)
        
        output.yesButtonDidTap
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] roomId in
                guard let presentingViewController = self?.presentingViewController as? UINavigationController else { return }
                self?.dismiss(animated: true, completion: {
                    presentingViewController.pushViewController(ChooseCharacterViewController(roomId: roomId), animated: true)
                })
            })
            .store(in: &self.cancellable)
    }
}
