//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class CreateRoomViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let createRoomView: CreateRoomView = CreateRoomView()
    
    // MARK: - property
    
    private let roomParticipationRepository: RoomParticipationRepository = RoomParticipationRepositoryImpl()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.createRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
    }
    
    // FIXME: 플로우 연결 하면서 변경 될 예정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - override
    
    override func configureUI() {
        super.configureUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func endEditingView() {
        self.createRoomView.endEditingView()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.createRoomView.configureDelegate(self)
    }
    
    private func pushDetailWaitViewController(roomId: Int) {
        guard let navigationController = self.presentingViewController as? UINavigationController else { return }
        let viewModel = DetailWaitViewModel(roomIndex: roomId,
                                            detailWaitService: DetailWaitService(repository: DetailRoomRepositoryImpl()))
        let viewController = DetailWaitViewController(viewModel: viewModel)
        
        navigationController.popViewController(animated: true)
        navigationController.pushViewController(viewController, animated: false)
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .createRoomInvitedCode, object: nil)
        }
    }
    
    // MARK: - network
    
    private func requestCreateRoom(room: CreatedRoomRequestDTO) {
        Task {
            do {
                let roomId = try await self.roomParticipationRepository.dispatchCreateRoom(room: room)
                self.pushDetailWaitViewController(roomId: roomId)
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

extension CreateRoomViewController: CreateRoomViewDelegate {
    func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    func requestCreateRoom(roomInfo: RoomListItem, colorIndex: Int) {
        let room = CreatedRoomInfoRequestDTO(title: roomInfo.title,
                                             capacity: roomInfo.capacity,
                                             startDate: roomInfo.startDate,
                                             endDate: roomInfo.endDate)
        let member = MemberInfoRequestDTO(colorIndex: colorIndex)
        self.requestCreateRoom(room: CreatedRoomRequestDTO(room: room, member: member))
    }
}
