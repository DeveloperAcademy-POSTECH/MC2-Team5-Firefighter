//
//  NicknameView.swift
//  Manito
//
//  Created by 이성호 on 2023/09/02.
//

import UIKit

import SnapKit

final class NicknameView: UIView {
    
    // MARK: - ui components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        label.text = self.title
        return label
    }()
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        textField.backgroundColor = .darkGrey002
        textField.attributedPlaceholder = NSAttributedString(string: TextLiteral.createNickNameViewControllerAskNickName, attributes:attributes)
        textField.font = .font(.regular, ofSize: 18)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.becomeFirstResponder()
        textField.delegate = self
        return textField
    }()
    private lazy var textLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "0/\(maxLength)"
        label.font = .font(.regular, ofSize: 20)
        label.textColor = .grey002
        return label
    }()
    private let doneButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.done
        button.isDisabled = true
        return button
    }()
    
    // MARK: - property
    
    private let title: String
    private let maxLength = 5
    
    // MARK: - init
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        self.setupLayout()
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
        
        self.addSubview(self.nicknameTextField)
        self.nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(60)
        }
        
        self.addSubview(self.textLimitLabel)
        self.textLimitLabel.snp.makeConstraints {
            $0.top.equalTo(self.nicknameTextField.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(23)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func endEditingView() {
        if !self.doneButton.isTouchInside {
            self.endEditing(true)
        }
    }
    
    // MARK: - selector
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.doneButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 30)
            })
        }
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.doneButton.transform = .identity
        })
    }
}

extension NicknameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nicknameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //        setCounter(count: textField.text?.count ?? 0)
        //        checkMaxLength(textField: roomsNameTextField, maxLength: maxLength)
        //
        //        let hasText = roomsNameTextField.hasText
        //        doneButton.isDisabled = !hasText
    }
}
