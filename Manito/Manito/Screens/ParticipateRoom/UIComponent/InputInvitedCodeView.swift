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
    
    // MARK: - property
    
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
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.becomeFirstResponder()
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
    
    // MARK: - func
    
    private func render() {
        self.addSubview(roomCodeTextField)
        roomCodeTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addSubview(roomsTextLimit)
        roomsTextLimit.snp.makeConstraints {
            $0.top.equalTo(roomCodeTextField.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
    }
    
    private func setCounter(count: Int) {
        if count <= maxLength {
            roomsTextLimit.text = "\(count)/\(maxLength)"
        } else {
            roomsTextLimit.text = "\(maxLength)/\(maxLength)"
        }
    }
    
    private func checkMaxLength(textField: UITextField, maxLength: Int) {
        if let text = textField.text {
            if text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                let fixedText = text[text.startIndex..<endIndex]
                textField.text = fixedText + " "
                
                DispatchQueue.main.async {
                    self.roomCodeTextField.text = String(fixedText)
                }
            }
        }
    }
}

extension InputInvitedCodeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomCodeTextField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setCounter(count: textField.text?.count ?? 0)
        checkMaxLength(textField: roomCodeTextField, maxLength: maxLength)
        
        guard let textCount = roomCodeTextField.text?.count else { return }
        let hasText = textCount >= maxLength
        changeNextButtonEnableStatus?(hasText)
    }
}
