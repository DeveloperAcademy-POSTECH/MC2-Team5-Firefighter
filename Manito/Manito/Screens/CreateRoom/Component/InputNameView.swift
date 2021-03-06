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
        texField.attributedPlaceholder = NSAttributedString(string: "방 이름을 적어주세요", attributes:attributes)
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
    
    var enableButton: (() -> ())?
    
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
        roomsTextLimit.text = "\(count)/\(maxLength)"
        checkMaxLength(textField: roomsNameTextField, maxLength: maxLength)
    }
    
    private func checkMaxLength(textField: UITextField, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
}

extension InputNameView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setCounter(count: textField.text?.count ?? 0)
        enableButton?()
    }
}
