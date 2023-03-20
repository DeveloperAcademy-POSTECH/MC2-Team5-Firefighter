//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class CreateRoomViewController: BaseViewController {
    
    private enum RoomState: Int {
        case inputName = 0
        case inputPerson = 1
        case inputDate = 2
        case checkRoom = 3
    }
            
    // MARK: - ui component
    
    private lazy var createRoomView: CreateRoomView = CreateRoomView()
        
    // MARK: - property
    
    private let roomService: RoomProtocol = RoomAPI(apiService: APIService())
    private var name: String = ""
    private var person: Int = 0
    private var notiIndex: RoomState = .inputName
    private var roomInfo: RoomDTO?
    
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
    
    private func changePreviousRoomIndex() {
        self.notiIndex = RoomState.init(rawValue: self.notiIndex.rawValue - 1) ?? RoomState.inputName
        self.changedInputView()
    }
    
    private func dismissCurrentView() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    private func changeNextRoom() {
        switch self.notiIndex {
        case .inputName:
            guard let text = self.createRoomView.nameView.roomsNameTextField.text else { return }
            self.name = text
            self.setDataInCheckView(name: self.name)
            self.changeNotiIndex()
            self.changedInputView()
            self.createRoomView.nameView.roomsNameTextField.resignFirstResponder()
        case .inputPerson:
            self.person = Int(self.createRoomView.personView.personSlider.value)
            self.setDataInCheckView(person: self.person)
            self.changeNotiIndex()
            self.changedInputView()
        case .inputDate:
            self.setDataInCheckView(date: "\(createRoomView.dateView.calendarView.getTempStartDate()) ~ \(createRoomView.dateView.calendarView.getTempEndDate())")
            self.changeNotiIndex()
            self.changedInputView()
        case .checkRoom:
            self.roomInfo = RoomDTO(title: self.name,
                                    capacity: self.person,
                                    startDate: "20\(self.createRoomView.dateView.calendarView.getTempStartDate())",
                                    endDate: "20\(self.createRoomView.dateView.calendarView.getTempEndDate())")
            let viewController = ChooseCharacterViewController(statusMode: .createRoom, roomId: nil)
            viewController.roomInfo = self.roomInfo
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func changedInputView() {
        switch self.notiIndex {
        case .inputName:
            self.createRoomView.setInputNameView()
        case .inputPerson:
            self.createRoomView.setInputPersonView()
        case .inputDate:
            self.createRoomView.setInputDateView()
        case .checkRoom:
            self.createRoomView.setCheckRoomView()
        }
    }
    
    private func setDataInCheckView(name: String = "", person: Int = 0, date: String = "" ) {
        switch self.notiIndex {
        case .inputName:
            self.createRoomView.checkView.name = name
        case .inputPerson:
            self.createRoomView.checkView.participants = person
        case .inputDate:
            self.createRoomView.checkView.dateRange = date
        default:
            return
        }
    }
    
    private func changeNotiIndex() {
        switch self.notiIndex {
        case .inputName:
            self.notiIndex = .inputPerson
        case .inputPerson:
            self.notiIndex = .inputDate
        case .inputDate:
            self.notiIndex = .checkRoom
        default:
            return
        }
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
    func didTapCloseButton() {
        self.dismissCurrentView()
    }
    
    func didTapNextButton() {
        self.changeNextRoom()
    }
    
    func didTapBackButton() {
        self.changePreviousRoomIndex()
    }
}
