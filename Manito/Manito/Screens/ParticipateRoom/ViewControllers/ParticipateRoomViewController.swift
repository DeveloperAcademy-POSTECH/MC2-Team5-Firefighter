//
//  ParticipateRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

final class ParticipateRoomViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let participateRoomView: ParticipateRoomView = ParticipateRoomView()
    
    // MARK: - property
    
//    private let roomParticipationRepository: RoomParticipationRepository = RoomParticipationRepositoryImpl()
    private let viewModel: ParticipateRoomViewModel
    
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
        let input = ParticipateRoomViewModel.Input()
        return self.viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: ParticipateRoomViewModel.Output) {
        
    }
    
    // MARK: - network
    
//    private func dispatchInviteCode(_ code : String) {
//        Task {
//            do {
//                let data = try await self.roomParticipationRepository.dispatchVerifyCode(code: code)
//                guard let id = data.id else { return }
//                let viewController = CheckRoomViewController()
//                viewController.modalPresentationStyle = .overFullScreen
//                viewController.modalTransitionStyle = .crossDissolve
//                viewController.roomInfo = data
//                viewController.roomId = id
//
//                self.present(viewController, animated: true)
//            } catch NetworkError.serverError {
//                print("server Error")
//            } catch NetworkError.encodingError {
//                print("encoding Error")
//            } catch NetworkError.clientError(let message) {
//                self.makeAlert(title: TextLiteral.checkRoomViewControllerErrorAlertTitle, message: TextLiteral.checkRoomViewControllerErrorAlertMessage)
//                print("client Error: \(String(describing: message))")
//            }
//        }
//    }
}

extension ParticipateRoomViewController: ParticipateRoomViewDelegate {
    func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    func nextButtonDidTap(code: String) {
//        self.dispatchInviteCode(code)
    }
    
    func observeNextNotification(roomId: Int) {
        self.navigationController?.pushViewController(ChooseCharacterViewController(roomId: roomId), animated: true)
    }
}
