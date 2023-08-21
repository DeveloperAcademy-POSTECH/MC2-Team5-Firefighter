//
//  InputNameView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import UIKit

import SnapKit

final class InputTitleView: UIView {
    
    // MARK: - ui component
    
    private lazy var roomsNameTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        textField.backgroundColor = .darkGrey002
        textField.attributedPlaceholder = NSAttributedString(string: TextLiteral.inputNameViewRoomNameText,
                                                             attributes:attributes)
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
    private lazy var roomsTextLimitLabel : UILabel = {
        let label = UILabel()
        label.text = "0/\(self.maxLength)"
        label.font = .font(.regular, ofSize: 20)
        label.textColor = .grey002
        return label
    }()
    
    // MARK: - property
    
    var changeNextButtonEnableStatus: ((Bool) -> ())?
    private var maxLength: Int = 8
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.roomsNameTextField)
        self.roomsNameTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addSubview(self.roomsTextLimitLabel)
        self.roomsTextLimitLabel.snp.makeConstraints {
            $0.top.equalTo(self.roomsNameTextField.snp.bottom).offset(10)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func setCounter(count: Int) {
        if count <= maxLength {
            self.roomsTextLimitLabel.text = "\(count)/\(self.maxLength)"
        } else {
            self.roomsTextLimitLabel.text = "\(self.maxLength)/\(self.maxLength)"
        }
    }
    
    private func checkMaxLength(textField: UITextField, maxLength: Int) {
        if let text = textField.text {
            if text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                let fixedText = text[text.startIndex..<endIndex]
                textField.text = fixedText + " "
                
                DispatchQueue.main.async {
                    self.roomsNameTextField.text = String(fixedText)
                }
            }
        }
    }
    
    func getTextFieldContent() -> String {
        guard let text = self.roomsNameTextField.text else { return "" }
        return text
    }
}

extension InputTitleView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.setCounter(count: textField.text?.count ?? 0)
        self.checkMaxLength(textField: self.roomsNameTextField, maxLength: self.maxLength)
        
        let hasText = textField.hasText
        self.changeNextButtonEnableStatus?(hasText)
    }
}
