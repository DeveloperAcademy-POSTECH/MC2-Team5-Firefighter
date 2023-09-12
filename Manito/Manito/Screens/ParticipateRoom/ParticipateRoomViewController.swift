//
//  ParticipateRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

final class ParticipateRoomViewController: UIViewController, Navigationable {
    
    // MARK: - ui component
    
    private let participateRoomView: ParticipateRoomView = ParticipateRoomView()
    
    // MARK: - property
    
    private let roomParticipationRepository: RoomParticipationRepository = RoomParticipationRepositoryImpl()
    
    // MARK: - init
    
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
        self.setupNavigation()
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
    
    // MARK: - network
    
    private func dispatchInviteCode(_ code : String) {
        Task {
            do {
                let data = try await self.roomParticipationRepository.dispatchVerifyCode(code: code)
                guard let id = data.id else { return }
                let viewController = CheckRoomViewController()
                viewController.modalPresentationStyle = .overFullScreen
                viewController.modalTransitionStyle = .crossDissolve
                viewController.roomInfo = data
                viewController.roomId = id

                self.present(viewController, animated: true)
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                self.makeAlert(title: TextLiteral.checkRoomViewControllerErrorAlertTitle, message: TextLiteral.checkRoomViewControllerErrorAlertMessage)
                print("client Error: \(String(describing: message))")
            }
        }
    }
}

extension ParticipateRoomViewController: ParticipateRoomViewDelegate {
    func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    func nextButtonDidTap(code: String) {
        self.dispatchInviteCode(code)
    }
    
    func observeNextNotification(roomId: Int) {
        self.navigationController?.pushViewController(ChooseCharacterViewController(roomId: roomId), animated: true)
    }
}
