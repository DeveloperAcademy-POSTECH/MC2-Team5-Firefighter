//
//  ParticipateRoomView.swift
//  Manito
//
//  Created by 이성호 on 2023/05/11.
//

import Combine
import UIKit

import SnapKit

final class ParticipateRoomView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.Common.enterRoom.localized()
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.setImage(UIImage.Button.xmark, for: .normal)
        return button
    }()
    private let nextButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.Common.searchRoom.localized()
        button.isDisabled = true
        return button
    }()
    private let inputInvitedCodeView: InputInvitedCodeView = InputInvitedCodeView()
    
    // MARK: - property
    
    let nextButtonTapPublisher: PassthroughSubject<String, Never> = PassthroughSubject()
    var closeButtonTapPublisher: AnyPublisher<Void, Never> {
        self.closeButton.tapPublisher
    }
    var textFieldDidChangedPublisher: PassthroughSubject<String, Never> {
        return self.inputInvitedCodeView.textFieldDidChangedPublisher
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupButtonAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
                
        self.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).inset(-23)
            $0.height.equalTo(60)
        }
        
        self.addSubview(self.inputInvitedCodeView)
        self.inputInvitedCodeView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }
        
        self.bringSubviewToFront(self.nextButton)
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - func
    
    private func setupButtonAction() {
        let didTapNextButton = UIAction { [weak self] _ in
            guard let code = self?.inputInvitedCodeView.code() else { return }
            self?.nextButtonTapPublisher.send(code)
        }
        self.nextButton.addAction(didTapNextButton, for: .touchUpInside)
    }
    
    func configureNavigationBarItem(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let closeButton = UIBarButtonItem(customView: self.closeButton)
        
        navigationItem?.rightBarButtonItem = closeButton
        navigationItem?.leftBarButtonItem = nil
    }
    
    func endEditing() {
        if !self.nextButton.isTouchInside {
            self.endEditing(true)
        }
    }
    
    func toggleDoneButton(isEnabled: Bool) {
        self.nextButton.isDisabled = !isEnabled
    }
    
    func updateTextCount(count: Int, maxLength: Int) {
        self.inputInvitedCodeView.updateTextCount(count: count, maxLength: maxLength)
    }
    
    func updateTextFieldText(fixedText: String) {
        self.inputInvitedCodeView.updateTextFieldText(fixedText: fixedText)
    }
}
