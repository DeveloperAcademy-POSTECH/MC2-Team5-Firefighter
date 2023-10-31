//
//  CreateRoomView.swift
//  Manito
//
//  Created by 이성호 on 2023/08/02.
//

import Combine
import UIKit

import SnapKit

final class CreateRoomView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.Common.createRoom.localized()
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.Button.xmark, for: .normal)
        button.tintColor = .grey001
        return button
    }()
    private let nextButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.CreateRoom.next.localized()
        button.isDisabled = true
        return button
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.Button.back, for: .normal)
        button.setTitle(" " + TextLiteral.CreateRoom.previous.localized(), for: .normal)
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
    
    let nextButtonDidTapPublisher = PassthroughSubject<CreateRoomStep, Never>()
    let backButtonDidTapPublisher = PassthroughSubject<CreateRoomStep, Never>()
    var closeButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.closeButton.tapPublisher
    }
    var textFieldPublisher: PassthroughSubject<String, Never> {
        return self.roomTitleView.textFieldPublisher
    }
    var sliderPublisher: PassthroughSubject<Int, Never> {
        return self.roomCapacityView.sliderPublisher
    }
    var startDateTapPublisher: PassthroughSubject<String, Never> {
        return self.roomDateView.startDateTapPublisher
    }
    var endDateTapPublisher: PassthroughSubject<String, Never> {
        return self.roomDateView.endDateTapPublisher
    }
    var characterIndexTapPublisher: CurrentValueSubject<Int, Never> {
        return self.characterCollectionView.characterIndexTapPublisher
    }
    // MARK: - property
    
    private var roomStep: CreateRoomStep = .inputTitle {
        willSet(step) {
            self.manageStepView(step: step)
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(SizeLiteral.leadingTrailingPadding)
        }
        
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        self.addSubview(self.backButton)
        self.backButton.snp.makeConstraints {
            $0.top.equalTo(self.closeButton)
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        self.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(SizeLiteral.leadingTrailingPadding)
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).inset(-23)
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
                    $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
                    $0.bottom.equalTo(self.nextButton.snp.top)
                }
            }
        
        self.bringSubviewToFront(self.nextButton)
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
        self.roomStep = .inputTitle
    }

    // MARK: - func

    private func setupAction() {
        let nextAction = UIAction { [weak self] _ in
            guard let currentStep = self?.roomStep else { return }
            self?.nextButtonDidTapPublisher.send(currentStep)
        }
        self.nextButton.addAction(nextAction, for: .touchUpInside)
        
        let backAction = UIAction { [weak self] _ in
            guard let currentStep = self?.roomStep else { return }
            self?.backButtonDidTapPublisher.send(currentStep)
        }
        self.backButton.addAction(backAction, for: .touchUpInside)
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
            self.endEditing(true)
        case .inputCapacity:
            self.nextButton(isEnable: false)
        default:
            break
        }
    }
    
    private func nextButton(isEnable: Bool) {
        self.nextButton.isDisabled = !isEnable
    }
    
    func endEditingView() {
        if !self.nextButton.isTouchInside {
            self.endEditing(true)
        }
    }
    
    func backButtonDidTap(previousStep: CreateRoomStep) {
        self.roomStep = previousStep
    }
    
    func nextButtonDidTap(currentStep: CreateRoomStep, nextStep: CreateRoomStep) {
        self.runActionAtStep(at: currentStep)
        self.roomStep = nextStep
    }
    
    func toggleNextButton(isEnable: Bool) {
        self.nextButton.isDisabled = !isEnable
    }
    
    func updateTitleCount(count: Int, maxLength: Int) {
        self.roomTitleView.updateTitleCount(count: count, maxLength: maxLength)
    }
    
    func updateRoomTitle(title: String) {
        self.roomInfoView.updateRoomTitle(title: title)
    }
    
    func updateTextFieldText(fixedTitle: String) {
        self.roomTitleView.updateTextFieldText(fixedTitle: fixedTitle)
    }
    
    func updateCapacity(capacity: Int) {
        self.roomCapacityView.updateCapacity(capacity: capacity)
    }
    
    func updateRoomCapacity(capacity: Int) {
        self.roomInfoView.updateRoomCapacity(capacity: capacity)
    }
    
    func updateRoomDateRange(range: String) {
        self.roomInfoView.updateRoomDateRange(range: range)
    }
    
    private func manageStepView(step: CreateRoomStep) {
        self.updateHiddenStepView(at: step)
        self.updateHiddenBackButton(at: step)
        switch step {
        case .inputTitle:
            self.updateRoomTitleViewAnimation()
        case .inputCapacity:
            self.updateRoomCapacityViewAnimation()
            self.nextButton(isEnable: true)
        case .inputDate:
            self.updateRoomDateViewAnimation()
        case .checkRoom:
            self.updateRoomDataCheckViewAnimation()
        case .chooseCharacter:
            self.updateChooseCharacterViewAnimation()
        }
    }
}

enum CreateRoomStep {
    case inputTitle, inputCapacity, inputDate, checkRoom, chooseCharacter
    
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

