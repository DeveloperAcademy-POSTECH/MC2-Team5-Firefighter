//
//  ChooseRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/18.
//

import UIKit

import SnapKit

final class ChooseCharacterViewController: BaseViewController {
    // FIXME: Status 삭제예정
    enum Status {
        case createRoom
        case enterRoom
    }
    
    // MARK: - ui component

    private let chooseCharacterView: ChooseCharacterView = ChooseCharacterView()
    
    // MARK: - property
    
    private let roomService: RoomProtocol = RoomAPI(apiService: APIService())
    // FIXME: 삭제예정
    private var statusMode: Status
    private var roomId: Int?
    private var characterIndex: Int = 0
    // FIXME: private 변경 예정
    var roomInfo: RoomDTO?
    
    // MARK: - init
    
    init(statusMode: Status, roomId: Int?) {
        self.statusMode = statusMode
        self.roomId = roomId
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.configureNavigationController()
    }
    
    override func loadView() {
        self.view = self.chooseCharacterView
    }
    
    // MARK: - override
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        // FIXME: ParticipateRoomVC 수정 시 삭제 예정
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.chooseCharacterView.configureDelegate(self)
    }
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.chooseCharacterView.configureNavigationItem(navigationController)
    }
    
    private func didTapEnterButton() {
        // FIXME: statusMode 삭제 이후 enterRoom 변경 예정 
        switch self.statusMode {
        case .createRoom:
            guard let roomInfo = self.roomInfo else { return }
            self.requestCreateRoom(room: CreateRoomDTO(room: RoomDTO(title: roomInfo.title,
                                                                capacity: roomInfo.capacity,
                                                                startDate: roomInfo.startDate,
                                                                endDate: roomInfo.endDate) ,
                                                  member: MemberDTO(colorIdx: characterIndex)))
        case .enterRoom:
            self.requestJoinRoom()
        }
    }
    
    // MARK: - network
    
    private func requestJoinRoom() {
        Task {
            do {
                guard let id = self.roomId else { return }
                let status = try await self.roomService.dispatchJoinRoom(roodId: id.description,
                                                                         dto: MemberDTO(colorIdx: self.characterIndex))
                if status == 201 {
                    guard let navigationController = self.presentingViewController as? UINavigationController else { return }
                    guard let id = self.roomId else { return }
                    let viewController = DetailWaitViewController(roomIndex: id)
                    self.dismiss(animated: true) {
                        navigationController.pushViewController(viewController, animated: true)
                    }
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
                self.makeAlert(title: "이미 참여중인 방입니다", message: "참여중인 애니또 리스트를 확인해 보세요", okAction: { [weak self] _ in
                    self?.dismiss(animated: true)
                })
            }
        }
    }
    
    func requestCreateRoom(room: CreateRoomDTO) {
        Task {
            do {
                guard
                    let roomId = try await self.roomService.postCreateRoom(body: room),
                    let navigationController = self.presentingViewController as? UINavigationController
                else { return }
                let viewController = DetailWaitViewController(roomIndex: roomId)
                navigationController.popViewController(animated: true)
                navigationController.pushViewController(viewController, animated: false)
                
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .createRoomInvitedCode, object: nil)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
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
        self.characterIndex = characterIndex
        self.didTapEnterButton()
    }
}
