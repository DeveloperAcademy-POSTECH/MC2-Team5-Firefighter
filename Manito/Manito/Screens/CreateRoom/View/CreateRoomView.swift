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
        case inputTitle = 0
        case inputParticipants = 1
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
    private let roomTitleView: InputTitleView = InputTitleView()
    private let roomParticipantsView: InputParticipants = InputParticipants()
    private let roomDateView: InputDateView = InputDateView()
    private let roomDataCheckView: CheckRoomView = CheckRoomView()
    
    // MARK: - property
    
    private var name: String = ""
    private var participants: Int = 0
    private var notiIndex: CreateRoomState = .inputTitle
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

        self.addSubview(self.roomTitleView)
        self.roomTitleView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }

        self.addSubview(self.roomParticipantsView)
        self.roomParticipantsView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }

        self.addSubview(self.roomDateView)
        self.roomDateView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }

        self.addSubview(self.roomDataCheckView)
        self.roomDataCheckView.snp.makeConstraints {
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
        case .inputTitle:
            guard let text = self.roomTitleView.roomsNameTextField.text else { return }
            self.name = text
            self.setDataInCheckView(name: self.name)
            self.changeNextRoomIndex()
            self.changedInputView()
            self.roomTitleView.roomsNameTextField.resignFirstResponder()
        case .inputParticipants:
            self.participants = Int(self.roomParticipantsView.personSlider.value)
            self.setDataInCheckView(participants: self.participants)
            self.changeNextRoomIndex()
            self.changedInputView()
        case .inputDate:
            self.setDataInCheckView(date: "\(self.roomDateView.calendarView.getTempStartDate()) ~ \(self.roomDateView.calendarView.getTempEndDate())")
            self.changeNextRoomIndex()
            self.changedInputView()
        case .checkRoom:
            self.roomInfo = RoomDTO(title: self.name,
                                    capacity: self.participants,
                                    startDate: "20\(self.roomDateView.calendarView.getTempStartDate())",
                                    endDate: "20\(self.roomDateView.calendarView.getTempEndDate())")
            self.delegate?.pushChooseCharacterViewController(roomInfo: self.roomInfo)
        }
    }
    
    private func changePreviousRoomIndex() {
        self.notiIndex = CreateRoomState.init(rawValue: self.notiIndex.rawValue - 1)!
        self.changedInputView()
    }
    
    private func changeNextRoomIndex() {
        self.notiIndex = CreateRoomState.init(rawValue: self.notiIndex.rawValue + 1)!
        self.changedInputView()
    }
    
    private func changedInputView() {
        switch self.notiIndex {
        case .inputTitle:
            self.setInputNameView()
        case .inputParticipants:
            self.setInputPersonView()
        case .inputDate:
            self.setInputDateView()
        case .checkRoom:
            self.setCheckRoomView()
        }
    }
    
    private func detectStartableStatus() {
        self.roomTitleView.changeNextButtonEnableStatus = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
        
        self.roomDateView.calendarView.changeButtonState = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
    }
    
    private func setInputNameView() {
        self.backButton.isHidden = true
        self.roomTitleView.fadeIn()
        self.roomTitleView.isHidden = false
        self.roomParticipantsView.fadeOut()
        self.roomParticipantsView.isHidden = true
    }

    private func setInputPersonView() {
        self.nextButton.isDisabled = false
        self.backButton.isHidden = false
        self.roomTitleView.fadeOut()
        self.roomTitleView.isHidden = true
        self.roomParticipantsView.fadeIn()
        self.roomParticipantsView.isHidden = false
        self.roomDateView.fadeOut()
        self.roomDateView.isHidden = true
    }

    private func setInputDateView() {
        self.roomDateView.calendarView.setupButtonState()
        self.roomParticipantsView.fadeOut()
        self.roomParticipantsView.isHidden = true
        self.roomDateView.fadeIn()
        self.roomDateView.isHidden = false
        self.roomDataCheckView.fadeOut()
        self.roomDataCheckView.isHidden = true
    }

    private func setCheckRoomView() {
        self.roomDateView.fadeOut()
        self.roomDateView.isHidden = true
        self.roomDataCheckView.fadeIn()
        self.roomDataCheckView.isHidden = false
    }

    private func setInputViewIsHidden() {
        self.roomParticipantsView.alpha = 0.0
        self.roomParticipantsView.isHidden = true
        self.roomDateView.alpha = 0.0
        self.roomDateView.isHidden = true
        self.roomDataCheckView.alpha = 0.0
        self.roomDataCheckView.isHidden = true
    }

    private func setDataInCheckView(name: String = "", participants: Int = 0, date: String = "" ) {
        switch self.notiIndex {
        case .inputTitle:
            self.roomDataCheckView.name = name
        case .inputParticipants:
            self.roomDataCheckView.participants = participants
        case .inputDate:
            self.roomDataCheckView.dateRange = date
        default:
            return
        }
    }
}
