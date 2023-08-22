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
    func requestCreateRoom(roomInfo: RoomInfo, colorIndex: Int)
}

final class CreateRoomView: UIView {
    
    fileprivate enum CreateRoomStep {
         case inputTitle, inputCapacity, inputDate, checkRoom, chooseCharacter
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
    private let roomCapacityView: InputCapacityView = InputCapacityView()
    private let roomDateView: InputDateView = InputDateView()
    private let roomInfoView: CheckRoomInfoView = CheckRoomInfoView()
    private let characterCollectionView: CharacterCollectionView = CharacterCollectionView()
    
    // MARK: - property
    
    private var roomInfo: RoomInfo?
    private weak var delegate: CreateRoomViewDelegate?
    private var roomStep: CreateRoomStep = .inputTitle {
        willSet(step) {
            self.manageStepView(step: step)
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupAction()
        self.setupNotificationCenter()
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
        self.addSubview(self.roomCapacityView)
        self.addSubview(self.roomDateView)
        self.addSubview(self.roomInfoView)
        self.addSubview(self.characterCollectionView)
        
        [self.roomTitleView, self.roomCapacityView, self.roomDateView, self.roomInfoView, self.characterCollectionView]
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
            guard let currentStep = self?.roomStep else { return }
            guard let nextStep = self?.moveToNextStep(from: currentStep) else { return }
            
            self?.runActionAtStep(at: currentStep)
            self?.roomStep = nextStep
        }
        self.nextButton.addAction(nextAction, for: .touchUpInside)
        
        let backAction = UIAction { [weak self] _ in
            guard let currentStep = self?.roomStep else { return }
            guard let previousStep = self?.moveToPreviousStep(from: currentStep) else { return }
            self?.roomStep = previousStep
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
    
    private func moveToNextStep(from step: CreateRoomStep) -> CreateRoomStep {
        return step.next()
    }
    
    private func moveToPreviousStep(from step: CreateRoomStep) -> CreateRoomStep {
        return step.previous()
    }
    
    private func detectStartableStatus() {
        self.roomTitleView.changeNextButtonEnableStatus = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
        
        self.roomDateView.calendarView.changeButtonState = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
        }
    }
    
    private func updateHiddenStepView(at step: CreateRoomStep) {
        self.roomTitleView.isHidden = !(step == .inputTitle)
        self.roomCapacityView.isHidden = !(step == .inputCapacity)
        self.roomDateView.isHidden = !(step == .inputDate)
        self.roomInfoView.isHidden = !(step == .checkRoom)
        self.characterCollectionView.isHidden = !(step == .chooseCharacter)
    }
    
    private func updateHiddenBackButton(at step: CreateRoomStep) {
        self.backButton.isHidden = !(step == .inputCapacity || step == .inputDate || step == .checkRoom || step == .chooseCharacter)
    }
    
    private func updateRoomTitleViewAnimation() {
        self.roomCapacityView.fadeOut()
        self.roomTitleView.fadeIn()
    }
    
    private func updateRoomCapacityViewAnimation() {
        self.roomTitleView.fadeOut()
        self.roomCapacityView.fadeIn()
        self.roomDateView.fadeOut()
    }
    
    private func updateRoomDateViewAnimation() {
        self.roomCapacityView.fadeOut()
        self.roomDateView.fadeIn()
        self.roomInfoView.fadeOut()
    }
    
    private func updateRoomDataCheckViewAnimation() {
        self.roomDateView.fadeOut()
        self.roomInfoView.fadeIn()
        self.characterCollectionView.fadeOut()
    }
    
    private func updateChooseCharacterViewAnimation() {
        self.roomInfoView.fadeOut()
        self.characterCollectionView.fadeIn()
    }
    
    private func runActionAtStep(at step: CreateRoomStep) {
        switch step {
        case .inputTitle:
            self.updateRoomTitle()
            self.endEditing(true)
        case .inputCapacity:
            self.updateRoomCapacity()
            self.disabledNextButton()
        case .inputDate:
            self.updateRoomDate()
        case .checkRoom:
               break
        case .chooseCharacter:
            let colorIndex = self.characterCollectionView.characterIndex
            self.delegate?.requestCreateRoom(roomInfo: RoomInfo(id: nil,
                                                                capacity: self.roomInfoView.capacity,
                                                                title: self.roomInfoView.title,
                                                                startDate: "20\(self.roomDateView.calendarView.getTempStartDate())",
                                                                endDate: "20\(self.roomDateView.calendarView.getTempEndDate())",
                                                                state: nil),
                                             colorIndex: colorIndex)
        }
    }
    
    private func updateRoomTitle() {
        let title = self.roomTitleView.textFieldText()
        self.roomInfoView.updateRoomTitle(title: title)
    }
    
    private func updateRoomCapacity() {
        let capacity = self.roomCapacityView.sliderValue()
        self.roomInfoView.updateRoomCapacity(capacity: capacity)
    }
    
    private func disabledNextButton() {
        self.nextButton.isDisabled = true
    }

    private func updateRoomDate() {
        let startDate = self.roomDateView.calendarView.getTempStartDate()
        let endDate = self.roomDateView.calendarView.getTempEndDate()
        let roomDateRange = "\(startDate) ~ \(endDate)"
        self.roomInfoView.updateRoomDateRange(range: roomDateRange)
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
    
    private func manageStepView(step: CreateRoomStep) {
        self.updateHiddenStepView(at: step)
        self.updateHiddenBackButton(at: step)
        switch step {
        case .inputTitle:
            self.updateRoomTitleViewAnimation()
        case .inputCapacity:
            self.updateRoomCapacityViewAnimation()
        case .inputDate:
            self.updateRoomDateViewAnimation()
        case .checkRoom:
            self.updateRoomDataCheckViewAnimation()
        case .chooseCharacter:
            self.updateChooseCharacterViewAnimation()
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

private extension CreateRoomView.CreateRoomStep {
    func next() -> Self {
        switch self {
        case .inputTitle:
            return .inputCapacity
        case .inputCapacity:
            return .inputDate
        case .inputDate:
            return .checkRoom
        case .checkRoom:
            return .chooseCharacter
        case .chooseCharacter:
            return .chooseCharacter
        }
    }
    
    func previous() -> Self {
        switch self {
        case .inputTitle:
            return .inputTitle
        case .inputCapacity:
            return .inputTitle
        case .inputDate:
            return .inputCapacity
        case .checkRoom:
            return .inputDate
        case .chooseCharacter:
            return .checkRoom
        }
    }
}
