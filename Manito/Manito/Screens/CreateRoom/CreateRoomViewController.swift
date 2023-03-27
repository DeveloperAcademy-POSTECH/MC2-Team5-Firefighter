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
    
    private lazy var createRoomView: CreateRoomView = CreateRoomView()

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
        self.view = self.createRoomView
    }
    
    // MARK: - override
    
    override func configureUI() {
        super.configureUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func endEditingView() {
        self.createRoomView.endEditinView()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.createRoomView.configureDelegate(self)
    }
}

extension CreateRoomViewController: CreateRoomViewDelegate {
    func pushChooseCharacterViewController(roomInfo: RoomDTO?) {
        let viewController = ChooseCharacterViewController(statusMode: .createRoom, roomId: nil)
        viewController.roomInfo = roomInfo
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didTapCloseButton() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}
