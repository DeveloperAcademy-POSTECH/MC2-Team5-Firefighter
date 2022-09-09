//
//  InputInvitedCodeView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

final class InputInvitedCodeView: UIView {
    
    private let maxLength = 6
    
    var changeNextButtonEnableStatus: ((Bool) -> ())?
    
    // MARK: - Property
    
    lazy var roomCodeTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        textField.backgroundColor = .darkGrey002
        textField.attributedPlaceholder = NSAttributedString(string: TextLiteral.inputInvitedCodeViewRoomCodeText, attributes: attributes)
        textField.textAlignment = .center
        textField.makeBorderLayer(color: .white)
        textField.font = .font(.regular, ofSize: 18)
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var roomsTextLimit : UILabel = {
        let label = UILabel()
        label.text = "\(String(describing: roomCodeTextField.text?.count ?? 0))/\(maxLength)"
        label.font = .font(.regular, ofSize: 20)
        label.textColor = .grey002
        return label
    }()
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        self.addSubview(roomCodeTextField)
        roomCodeTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addSubview(roomsTextLimit)
        roomsTextLimit.snp.makeConstraints {
            $0.top.equalTo(roomCodeTextField.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
    }
    
    // MARK: - func
    
    private func setCounter(count: Int) {
        roomsTextLimit.text = "\(count)/\(maxLength)"
        checkMaxLength(textField: roomCodeTextField, maxLength: maxLength)
    }
    
    private func checkMaxLength(textField: UITextField, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
}

extension InputInvitedCodeView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setCounter(count: textField.text?.count ?? 0)
        
        let hasText = roomCodeTextField.hasText
        changeNextButtonEnableStatus?(hasText)
    }
}
