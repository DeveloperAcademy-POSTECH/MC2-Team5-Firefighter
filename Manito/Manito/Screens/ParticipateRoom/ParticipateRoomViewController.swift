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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
    }
    
    override func loadView() {
        self.view = self.participateRoomView
    }
    
    // FIXME: 플로우 연결 하면서 변경 될 예정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    // FIXME: 뒤로가기 버그 수정(PR에서 얘기후 삭제 예정)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - override
    
    override func setupNavigationBar() {
        // FIXME: navigation으로 변경하면서 삭제예정
        navigationController?.navigationBar.isHidden = true
    }
    
    override func endEditingView() {
        self.participateRoomView.endEditing()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.participateRoomView.configureDelegate(self)
    }
    
    
    // MARK: - network
    
    private func dispatchInviteCode() {
        Task {
            do {
                guard let code = self.participateRoomView.inputInvitedCodeView.roomCodeTextField.text else { return }
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
    
    func nextButtonDidTap() {
        self.dispatchInviteCode()
    }
    
    func observeNextNotification(roomId: Int) {
        self.navigationController?.pushViewController(ChooseCharacterViewController(statusMode: .enterRoom, roomId: roomId), animated: true)
    }
}
