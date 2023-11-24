//
//  ParticipationRoomDetailsViewController.swift
//  Manito
//
//  Created by 이성호 on 2022/06/15.
//

import Combine
import UIKit

import SnapKit

final class ParticipationRoomDetailsViewController: UIViewController {
    
    // MARK: - ui component
    
    private let participationRoomDetailsView: ParticipationRoomDetailsView = ParticipationRoomDetailsView()
    
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
        self.view = self.participationRoomDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindToViewModel()
        self.bindUI()
    }
    
    // MARK: - func
    
    private func bindToViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> ParticipationRoomDetailsViewModel.Output? {
        guard let viewModel = self.viewModel as? ParticipationRoomDetailsViewModel else { return nil }
        let input = ParticipationRoomDetailsViewModel.Input(viewDidLoad: self.viewDidLoadPublisher,
                                                            yesButtonDidTap: self.participationRoomDetailsView.yesButtonDidTapPublisher)
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: ParticipationRoomDetailsViewModel.Output?) {
        guard let output else { return }
        
        output.roomInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] roomInfo in
                self?.participationRoomDetailsView.updateRoomInfo(roomInfo: roomInfo)
            })
            .store(in: &self.cancellable)
        
        output.yesButtonDidTap
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] roomId in
                guard let self else { return }
                self.presentChooseCharacterViewController(roomId: roomId)
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.participationRoomDetailsView.noButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &self.cancellable)
    }
}

// MARK: - Helper

extension ParticipationRoomDetailsViewController {
    private func presentChooseCharacterViewController(roomId: Int) {
        guard let presentingViewController = self.presentingViewController as? UINavigationController else { return }
        self.dismiss(animated: true, completion: {
            let repository = RoomParticipationRepositoryImpl()
            let usecase = ParticipateRoomUsecaseImpl(repository: repository)
            let viewModel = ChooseCharacterViewModel(usecase: usecase, roomId: roomId)
            presentingViewController.pushViewController(ChooseCharacterViewController(viewModel: viewModel), animated: true)
        })
    }
}
