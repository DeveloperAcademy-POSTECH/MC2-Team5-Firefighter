//
//  CreateRoomView.swift
//  Manito
//
//  Created by 이성호 on 2023/03/20.
//

import UIKit

import SnapKit

protocol CreateRoomViewDelegate: AnyObject {
    func didTapCloseButton()
    func pushChooseCharacterViewController(roomInfo: RoomDTO?)
}

final class CreateRoomView: UIView {
    
    private enum CreateRoomState: Int {
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
    let nextButton: MainButton = {
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
    
    private var name: String = ""
    private var participants: Int = 0
    private var notiIndex: CreateRoomState = .inputName
    private var roomInfo: RoomDTO?
    private weak var delegate: CreateRoomViewDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAction()
        self.detectStartableStatus()
        self.setInputViewIsHidden()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    func configureDelegate(_ delegate: CreateRoomViewDelegate) {
        self.delegate = delegate
    }
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
        }

        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }

        self.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.top.equalTo(self.closeButton)
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }

        self.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(23)
            $0.height.equalTo(60)
        }

        self.addSubview(self.nameView)
        self.nameView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }

        self.addSubview(self.personView)
        self.personView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }

        self.addSubview(self.dateView)
        self.dateView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }

        self.addSubview(self.checkView)
        self.checkView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }

        self.bringSubviewToFront(self.nextButton)
    }
    
    private func setupAction() {
        let closeAction = UIAction { [weak self] _ in
            self?.delegate?.didTapCloseButton()
        }
        self.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let nextAction = UIAction { [weak self] _ in
            self?.changeNextRoom()
        }
        self.nextButton.addAction(nextAction, for: .touchUpInside)
        
        let backAction = UIAction { [weak self] _ in
            self?.changePreviousRoomIndex()
        }
        self.backButton.addAction(backAction, for: .touchUpInside)
    }
    
    private func changeNextRoom() {
        switch self.notiIndex {
        case .inputName:
            guard let text = self.nameView.roomsNameTextField.text else { return }
            self.name = text
            self.setDataInCheckView(name: self.name)
            self.changeNotiIndex()
            self.changedInputView()
            self.nameView.roomsNameTextField.resignFirstResponder()
        case .inputPerson:
            self.participants = Int(self.personView.personSlider.value)
            self.setDataInCheckView(participants: self.participants)
            self.changeNotiIndex()
            self.changedInputView()
        case .inputDate:
            self.setDataInCheckView(date: "\(self.dateView.calendarView.getTempStartDate()) ~ \(self.dateView.calendarView.getTempEndDate())")
            self.changeNotiIndex()
            self.changedInputView()
        case .checkRoom:
            self.roomInfo = RoomDTO(title: self.name,
                                    capacity: self.participants,
                                    startDate: "20\(self.dateView.calendarView.getTempStartDate())",
                                    endDate: "20\(self.dateView.calendarView.getTempEndDate())")
            self.delegate?.pushChooseCharacterViewController(roomInfo: self.roomInfo)
        }
    }
    
    private func changePreviousRoomIndex() {
        self.notiIndex = CreateRoomState.init(rawValue: self.notiIndex.rawValue - 1)!
        self.changedInputView()
    }
    
    private func changeNotiIndex() {
        self.notiIndex = CreateRoomState.init(rawValue: self.notiIndex.rawValue + 1)!
        self.changedInputView()
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
    
    private func detectStartableStatus() {
        self.nameView.changeNextButtonEnableStatus = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
        
        self.dateView.calendarView.changeButtonState = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
    }
    
    private func setInputNameView() {
        self.backButton.isHidden = true
        self.nameView.fadeIn()
        self.nameView.isHidden = false
        self.personView.fadeOut()
        self.personView.isHidden = true
    }

    private func setInputPersonView() {
        self.nextButton.isDisabled = false
        self.backButton.isHidden = false
        self.nameView.fadeOut()
        self.nameView.isHidden = true
        self.personView.fadeIn()
        self.personView.isHidden = false
        self.dateView.fadeOut()
        self.dateView.isHidden = true
    }

    private func setInputDateView() {
        self.dateView.calendarView.setupButtonState()
        self.personView.fadeOut()
        self.personView.isHidden = true
        self.dateView.fadeIn()
        self.dateView.isHidden = false
        self.checkView.fadeOut()
        self.checkView.isHidden = true
    }

    private func setCheckRoomView() {
        self.dateView.fadeOut()
        self.dateView.isHidden = true
        self.checkView.fadeIn()
        self.checkView.isHidden = false
    }

    private func setInputViewIsHidden() {
        self.personView.alpha = 0.0
        self.personView.isHidden = true
        self.dateView.alpha = 0.0
        self.dateView.isHidden = true
        self.checkView.alpha = 0.0
        self.checkView.isHidden = true
    }

    private func setDataInCheckView(name: String = "", participants: Int = 0, date: String = "" ) {
        switch self.notiIndex {
        case .inputName:
            self.checkView.name = name
        case .inputPerson:
            self.checkView.participants = participants
        case .inputDate:
            self.checkView.dateRange = date
        default:
            return
        }
    }
}
