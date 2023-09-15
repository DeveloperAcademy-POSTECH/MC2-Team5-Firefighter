//
//  ParticipateRoomView.swift
//  Manito
//
//  Created by 이성호 on 2023/05/11.
//

import Combine
import UIKit

import SnapKit

protocol ParticipateRoomViewDelegate: AnyObject {
    func closeButtonDidTap()
}

final class ParticipateRoomView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.enterRoom
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        return button
    }()
    private let nextButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.searchRoom
        button.isDisabled = true
        return button
    }()
    let inputInvitedCodeView: InputInvitedCodeView = InputInvitedCodeView()
    
    // MARK: - property
    
    let nextButtonTapPublisher = PassthroughSubject<String, Never>()
    private weak var delegate: ParticipateRoomViewDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupButtonAction()
        self.setupNotificationCenter()
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
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
                
        self.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(23)
            $0.height.equalTo(60)
        }
        
        self.addSubview(self.inputInvitedCodeView)
        self.inputInvitedCodeView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(self.nextButton.snp.top)
        }
        
        self.bringSubviewToFront(self.nextButton)
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - func
    
    private func setupButtonAction() {
        let didTapCloseButton = UIAction { [weak self] _ in
            self?.delegate?.closeButtonDidTap()
        }
        
        let didTapNextButton = UIAction { [weak self] _ in
            guard let code = self?.inputInvitedCodeView.code() else { return }
            self?.nextButtonTapPublisher.send(code)
        }
        
        self.closeButton.addAction(didTapCloseButton, for: .touchUpInside)
        self.nextButton.addAction(didTapNextButton, for: .touchUpInside)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureDelegate(_ delegate: ParticipateRoomViewDelegate) {
        self.delegate = delegate
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
