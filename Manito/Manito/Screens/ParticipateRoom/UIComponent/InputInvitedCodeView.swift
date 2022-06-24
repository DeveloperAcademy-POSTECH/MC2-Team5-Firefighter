//
//  InputInvitedCodeView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

final class InputInvitedCodeView: UIView {
    
    // MARK: - Property
    private let roomsCodeTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        
        textField.backgroundColor = .subBackgroundGrey
        textField.attributedPlaceholder = NSAttributedString(string: "초대코드 입력", attributes: attributes)
        
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.textAlignment = .center
        return textField
    }()
    
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
        self.addSubview(roomsCodeTextField)
        roomsCodeTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
}
