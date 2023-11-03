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
    
    // MARK: - property
    
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
    var nextButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.nextButton.tapPublisher
    }
    var backButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.backButton.tapPublisher
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
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
    }

    // MARK: - func
    
    private func updateHiddenView(at step: Int) {
        self.roomTitleView.isHidden = !(step == 0)
        self.roomCapacityView.isHidden = !(step == 1)
        self.roomDateView.isHidden = !(step == 2)
        self.roomInfoView.isHidden = !(step == 3)
        self.characterCollectionView.isHidden = !(step == 4)
    }
    
    private func updateHiddenBackButton(at step: Int) {
        self.backButton.isHidden = !(step == 1 || step == 2 || step == 3 || step == 4)
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
    
    private func manageViewByNextStep(at step: Int, isEnabled: Bool) {
        switch step {
        case 0:
            self.updateRoomTitleViewAnimation()
        case 1:
            self.updateRoomCapacityViewAnimation()
            self.toggleNextButton(isEnable: isEnabled)
            self.endEditing(true)
        case 2:
            self.updateRoomDateViewAnimation()
            self.toggleNextButton(isEnable: isEnabled)
        case 3: self.updateRoomDataCheckViewAnimation()
        case 4: self.updateChooseCharacterViewAnimation()
        default: return
        }
    }
    
    func endEditingView() {
        if !self.nextButton.isTouchInside {
            self.endEditing(true)
        }
    }
    
    func toggleNextButton(isEnable: Bool) {
        self.nextButton.isDisabled = !isEnable
    }
    
    func updateTitleCount(count: Int, maxLength: Int) {
        self.roomTitleView.updateTitleCount(count: count, maxLength: maxLength)
    }
    
    func updateTextFieldText(fixedTitle: String) {
        self.roomTitleView.updateTextFieldText(fixedTitle: fixedTitle)
    }
    
    func updateCapacity(capacity: Int) {
        self.roomCapacityView.updateCapacity(capacity: capacity)
    }
    
    func updateRoomInfo(title: String, capacity: Int, range: String) {
        self.roomInfoView.updateRoomInfo(title: title,
                                         capacity: capacity,
                                         range: range)
    }
    
    func manageViewByStep(at step: Int, isEnabled: Bool) {
        self.updateHiddenView(at: step)
        self.updateHiddenBackButton(at: step)
        self.manageViewByNextStep(at: step, isEnabled: isEnabled)
    }
}
