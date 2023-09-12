//
//  ChooseRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/18.
//

import UIKit

import SnapKit

final class ChooseCharacterViewController: UIViewController, Navigationable {
    
    // MARK: - ui component

    private let chooseCharacterView: ChooseCharacterView = ChooseCharacterView()
    
    // MARK: - property
    
    private let roomParticipationRepository: RoomParticipationRepository = RoomParticipationRepositoryImpl()
    private let roomId: Int?
    
    // MARK: - init
    
    init(roomId: Int?) {
        self.roomId = roomId
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
//        self.setupNavigation()
        self.configureDelegation()
        self.configureNavigationController()
    }
    
    // MARK: - override
    
//    override func setupNavigationBar() {
//        super.setupNavigationBar()
//        // FIXME: ParticipateRoomVC 수정 시 삭제 예정
//        navigationController?.navigationBar.isHidden = false
//    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.chooseCharacterView.configureDelegate(self)
    }
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.chooseCharacterView.configureNavigationItem(navigationController)
    }
    
    private func pushDetailWaitViewController(roomId: Int) {
        guard let navigationController = self.presentingViewController as? UINavigationController else { return }
        let viewModel = DetailWaitViewModel(roomIndex: roomId, detailWaitService: DetailWaitService(repository: DetailRoomRepositoryImpl()))
        let viewController = DetailWaitViewController(viewModel: viewModel)
        self.dismiss(animated: true) {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func makeAlertWhenAlreadyJoin() {
        self.makeAlert(title: "이미 참여중인 방입니다", message: "참여중인 애니또 리스트를 확인해 보세요", okAction: { [weak self] _ in
            self?.dismiss(animated: true)
        })
    }
    
    // MARK: - network
    
    private func requestJoinRoom(characterIndex: Int) {
        Task {
            do {
                guard let roomId = self.roomId else { return }
                let status = try await self.roomParticipationRepository.dispatchJoinRoom(roomId: roomId.description,
                                                                                         member: MemberInfoRequestDTO(colorIndex: characterIndex))
                if status == 201 {
                    self.pushDetailWaitViewController(roomId: roomId)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
                self.makeAlertWhenAlreadyJoin()
            }
        }
    }
}

extension ChooseCharacterViewController: ChooseCharacterViewDelegate {
    func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    func joinButtonDidTap(characterIndex: Int) {
        self.requestJoinRoom(characterIndex: characterIndex)
    }
}
