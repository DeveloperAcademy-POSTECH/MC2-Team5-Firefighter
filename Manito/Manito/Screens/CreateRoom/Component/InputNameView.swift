//
//  InputNameView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import UIKit

import SnapKit

class InputNameView: UIView {
    private var maxLength = 8
    
    // MARK: - Property
    
    lazy var roomsNameTextField: UITextField = {
        let texField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        texField.backgroundColor = .darkGrey002
        texField.attributedPlaceholder = NSAttributedString(string: TextLiteral.inputNameViewRoomNameText, attributes:attributes)
        texField.textAlignment = .center
        texField.makeBorderLayer(color: .white)
        texField.font = .font(.regular, ofSize: 18)
        texField.returnKeyType = .done
        texField.delegate = self
        return texField
    }()
    
    private lazy var roomsTextLimit : UILabel = {
        let label = UILabel()
        label.text = "0/\(maxLength)"
        label.font = .font(.regular, ofSize: 20)
        label.textColor = .grey002
        return label
    }()
    
    var changeNextButtonEnableStatus: ((Bool) -> ())?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config
    
    private func render() {
        self.addSubview(roomsNameTextField)
        roomsNameTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addSubview(roomsTextLimit)
        roomsTextLimit.snp.makeConstraints {
            $0.top.equalTo(roomsNameTextField.snp.bottom).offset(10)
            $0.right.equalToSuperview()
        }
    }
    
    // MARK: - Funtions
    
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
                
                let when = DispatchTime.now() + 0.01
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.roomsNameTextField.text = String(fixedText)
                    self.setCounter(count: textField.text?.count ?? 0)
                }
            }
        }
    }
}

extension InputNameView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setCounter(count: textField.text?.count ?? 0)
        checkMaxLength(textField: roomsNameTextField, maxLength: maxLength)
        
        let hasText = roomsNameTextField.hasText
        changeNextButtonEnableStatus?(hasText)
    }
}
