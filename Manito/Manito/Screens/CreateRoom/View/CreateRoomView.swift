//
//  CreateRoomView.swift
//  Manito
//
//  Created by 이성호 on 2023/08/02.
//

import UIKit

import SnapKit

protocol CreateRoomViewDelegate: AnyObject {
    func didTapCloseButton()
    func pushChooseCharacterViewController(roomInfo: RoomDTO?)
}

final class CreateRoomView: UIView {
    
    private enum CreateRoomStep: Int {
             case inputTitle = 0, inputParticipants, inputDate, checkRoom
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
    private let roomTitleView: InputTitleView = InputTitleView()
    private let roomParticipantsView: InputParticipantsView = InputParticipantsView()
    private let roomDateView: InputDateView = InputDateView()
    private let roomInfoView: CheckRoomInfoView = CheckRoomInfoView()
    
    // MARK: - property
    
    private var roomInfo: RoomDTO?
    private weak var delegate: CreateRoomViewDelegate?
    private var roomStep: CreateRoomStep? = .inputTitle {
        willSet(step) {
            guard let stepIndex = step?.rawValue else { return }
            self.manageStepView(step: stepIndex)
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAction()
        self.detectStartableStatus()
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
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
        self.addSubview(self.roomParticipantsView)
        self.addSubview(self.roomDateView)
        self.addSubview(self.roomInfoView)
        
        [self.roomTitleView, self.roomParticipantsView, self.roomDateView, self.roomInfoView]
            .forEach {
                $0.snp.makeConstraints {
                    $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
                    $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
                    $0.bottom.equalTo(self.nextButton.snp.top)
                }
            }
        
        self.bringSubviewToFront(self.nextButton)
    }
    
    private func setupAction() {
        let closeAction = UIAction { [weak self] _ in
            self?.delegate?.didTapCloseButton()
        }
        self.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let nextAction = UIAction { [weak self] _ in
            self?.runActionAtStep(at: self?.roomStep?.rawValue ?? 0)
            self?.moveToNextStep()
        }
        self.nextButton.addAction(nextAction, for: .touchUpInside)
        
        let backAction = UIAction { [weak self] _ in
            self?.moveToPreviousStep()
        }
        self.backButton.addAction(backAction, for: .touchUpInside)
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
    
    private func moveToNextStep() {
        guard let stepIndex = self.roomStep?.rawValue,
              let nextStepIndex = CreateRoomStep(rawValue: stepIndex + 1) else { return }
        self.roomStep = nextStepIndex
    }
    
    private func moveToPreviousStep() {
        guard let stepIndex = self.roomStep?.rawValue,
              let previousStepIndex = CreateRoomStep(rawValue: stepIndex - 1) else { return }
        self.roomStep = previousStepIndex
    }
    
    private func detectStartableStatus() {
        self.roomTitleView.changeNextButtonEnableStatus = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
        
        self.roomDateView.calendarView.changeButtonState = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
    }
    
    private func setupHiddenStepView(at step: Int) {
        self.roomTitleView.isHidden = !(step == 0)
        self.roomParticipantsView.isHidden = !(step == 1)
        self.roomDateView.isHidden = !(step == 2)
        self.roomInfoView.isHidden = !(step == 3)
    }
    
    private func setupHiddenBackButton(at step: Int) {
        self.backButton.isHidden = !(step == 1 || step == 2 || step == 3)
    }
    
    private func setupRoomTitleViewAnimation() {
        self.roomParticipantsView.fadeOut()
        self.roomTitleView.fadeIn()
    }
    
    private func setupRoomParticipatesViewAnimation() {
        self.roomTitleView.fadeOut()
        self.roomParticipantsView.fadeIn()
        self.roomDateView.fadeOut()
    }
    
    private func setupRoomDateViewAnimation() {
        self.roomParticipantsView.fadeOut()
        self.roomDateView.fadeIn()
        self.roomInfoView.fadeOut()
    }
    
    private func setupRoomDataCheckViewAnimation() {
        self.roomDateView.fadeOut()
        self.roomInfoView.fadeIn()
    }
    
    private func runActionAtStep(at step: Int) {
        switch step {
        case 0:
            self.setupTitle()
        case 1:
            self.setupParticipates()
            self.disabledNextButton()
        case 2:
            self.setupDate()
        case 3:
            print("")
        default:
            break
        }
    }
    
    private func setupTitle() {
        guard let title = self.roomTitleView.roomsNameTextField.text else { return }
        self.roomInfoView.name = title
    }
    
    private func setupParticipates() {
        let participates = Int(self.roomParticipantsView.personSlider.value)
        self.roomInfoView.participants = participates
    }

    private func setupDate() {
        let startDate = self.roomDateView.calendarView.getTempStartDate()
        let endDate = self.roomDateView.calendarView.getTempEndDate()
        let roomDateRange = "\(startDate) ~ \(endDate)"
        self.roomInfoView.dateRange = roomDateRange
    }
    
    private func disabledNextButton() {
        self.nextButton.isDisabled = true
    }
    
    private func configureUI() {
        self.roomStep = .inputTitle
    }
    
    func configureDelegate(_ delegate: CreateRoomViewDelegate) {
        self.delegate = delegate
    }
    
    func endEditingView() {
        if !self.nextButton.isTouchInside {
            self.endEditing(true)
        }
    }
    
    func manageStepView(step: Int) {
        self.setupHiddenStepView(at: step)
        self.setupHiddenBackButton(at: step)
        switch step {
        case 0:
            self.setupRoomTitleViewAnimation()
        case 1:
            self.setupRoomParticipatesViewAnimation()
        case 2:
            self.setupRoomDateViewAnimation()
        case 3:
            self.setupRoomDataCheckViewAnimation()
        default:
            break
        }
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
