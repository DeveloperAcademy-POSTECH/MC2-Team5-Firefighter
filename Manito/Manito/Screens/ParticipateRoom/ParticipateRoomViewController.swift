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
    
    private let checkRoomInfoService: RoomProtocol = RoomAPI(apiService: APIService())
    
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
                let data = try await self.checkRoomInfoService
                    .dispatchVerification(body: code)
                if let info = data {
                    guard let id = info.id else { return }
                    let viewController = CheckRoomViewController()
                    viewController.modalPresentationStyle = .overFullScreen
                    viewController.modalTransitionStyle = .crossDissolve
                    viewController.verification = info
                    viewController.roomId = id
                    
                    present(viewController, animated: true)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                makeAlert(title: TextLiteral.checkRoomViewControllerErrorAlertTitle, message: TextLiteral.checkRoomViewControllerErrorAlertMessage)
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
        self.navigationController?.pushViewController(ChooseCharacterViewController(statusMode: .enterRoom, roomId: roomId), animated: true)
    }
}
