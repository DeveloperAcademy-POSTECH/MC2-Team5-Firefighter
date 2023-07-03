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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.createRoom
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        button.tintColor = .grey001
        return button
    }()
    private let nextButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.next
        button.isDisabled = true
        return button
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icBack, for: .normal)
        button.setTitle(" " + TextLiteral.previous, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 14)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    private let nameView: InputNameView = InputNameView()
    private let personView: InputPersonView = InputPersonView()
    private let dateView: InputDateView = InputDateView()
    private let checkView: CheckRoomView = CheckRoomView()
        
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
        self.detectStartableStatus()
        self.setupNotificationCenter()
        self.setInputViewIsHidden()
        self.setupAction()
    }
    // FIXME: 플로우 연결 하면서 변경 될 예정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - override
    
    override func setupLayout() {
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
        }
        
        self.view.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.view.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.top.equalTo(self.closeButton)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(23)
            $0.height.equalTo(60)
        }
        
        self.view.addSubview(self.nameView)
        self.nameView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }
        
        self.view.addSubview(self.personView)
        self.personView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }
        
        self.view.addSubview(self.dateView)
        self.dateView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }
        
        self.view.addSubview(self.checkView)
        self.checkView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }
        
        self.view.bringSubviewToFront(self.nextButton)
    }
    
    override func configureUI() {
        super.configureUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func endEditingView() {
        if !self.nextButton.isTouchInside {
            self.view.endEditing(true)
        }
    }
    
    // MARK: - func
    
    private func setupAction() {
        let closeAction = UIAction { [weak self] _ in
            self?.didTapCloseButton()
        }
        self.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let nextAction = UIAction { [weak self] _ in
            self?.didTapNextButton()
        }
        self.nextButton.addAction(nextAction, for: .touchUpInside)
        
        let backAction = UIAction { [weak self] _ in
            self?.didTapBackButton()
        }
        self.backButton.addAction(backAction, for: .touchUpInside)
    }
    
    private func didTapBackButton() {
        self.notiIndex = RoomState.init(rawValue: self.notiIndex.rawValue - 1) ?? RoomState.inputName
        self.changedInputView()
    }
    
    private func didTapCloseButton() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    private func didTapNextButton() {
        switch self.notiIndex {
        case .inputName:
            guard let text = self.nameView.roomsNameTextField.text else { return }
            self.name = text
            self.setDataInCheckView(name: self.name)
            self.changeNotiIndex()
            self.changedInputView()
            self.nameView.roomsNameTextField.resignFirstResponder()
        case .inputPerson:
            self.person = Int(self.personView.personSlider.value)
            self.setDataInCheckView(person: self.person)
            self.changeNotiIndex()
            self.changedInputView()
        case .inputDate:
            self.setDataInCheckView(date: "\(dateView.calendarView.getTempStartDate()) ~ \(dateView.calendarView.getTempEndDate())")
            self.changeNotiIndex()
            self.changedInputView()
        case .checkRoom:
            self.roomInfo = RoomDTO(title: self.name,
                                    capacity: self.person,
                                    startDate: "20\(self.dateView.calendarView.getTempStartDate())",
                                    endDate: "20\(self.dateView.calendarView.getTempEndDate())")
            let viewController = ChooseCharacterViewController(statusMode: .createRoom, roomId: nil)
            viewController.roomInfo = self.roomInfo
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func detectStartableStatus() {
        self.nameView.changeNextButtonEnableStatus = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
        
        self.dateView.calendarView.changeButtonState = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
    }
    
    private func changedInputView() {
        switch self.notiIndex {
        case .inputName:
            self.setInputNameView()
        case .inputPerson:
            self.setInputPersonView()
        case .inputDate:
            self.setInputDateView()
        case .checkRoom:
            self.setCheckRoomView()
        }
    }
    
    private func setInputNameView() {
        self.backButton.isHidden = true
        self.nameView.fadeIn(duration: 0.3)
        self.nameView.isHidden = false
        self.personView.fadeOut()
        self.personView.isHidden = true
    }
    
    private func setInputPersonView() {
        self.nextButton.isDisabled = false
        self.backButton.isHidden = false
        self.nameView.fadeOut()
        self.nameView.isHidden = true
        self.personView.fadeIn(duration: 0.3)
        self.personView.isHidden = false
        self.dateView.fadeOut()
        self.dateView.isHidden = true
    }
    
    private func setInputDateView() {
        self.dateView.calendarView.setupButtonState()
        self.personView.fadeOut()
        self.personView.isHidden = true
        self.dateView.fadeIn(duration: 0.3)
        self.dateView.isHidden = false
        self.checkView.fadeOut()
        self.checkView.isHidden = true
    }
    
    private func setCheckRoomView() {
        self.dateView.fadeOut()
        self.dateView.isHidden = true
        self.checkView.fadeIn(duration: 0.3)
        self.checkView.isHidden = false
    }
    
    private func setDataInCheckView(name: String = "", person: Int = 0, date: String = "" ) {
        switch self.notiIndex {
        case .inputName:
            self.checkView.name = name
        case .inputPerson:
            self.checkView.participants = person
        case .inputDate:
            self.checkView.dateRange = date
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
    
    private func setInputViewIsHidden() {
        self.personView.alpha = 0.0
        self.personView.isHidden = true
        self.dateView.alpha = 0.0
        self.dateView.isHidden = true
        self.checkView.alpha = 0.0
        self.checkView.isHidden = true
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
                self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 30)
            })
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.transform = .identity
        })
    }
}
