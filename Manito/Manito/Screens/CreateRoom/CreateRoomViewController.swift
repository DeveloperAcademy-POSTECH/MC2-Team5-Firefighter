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
        self.setupNotificationCenter()
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
        if !self.createRoomView.nextButton.isTouchInside {
            self.view.endEditing(true)
        }
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.createRoomView.configureDelegate(self)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: - selector
        
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.createRoomView.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 30)
            })
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.createRoomView.nextButton.transform = .identity
        })
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
