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
    lazy var roomsCodeTextField: UITextField = {
        let texField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        texField.backgroundColor = .darkGrey002
        texField.attributedPlaceholder = NSAttributedString(string: TextLiteral.inputInvitedCodeViewRoomCodeText, attributes: attributes)
        texField.textAlignment = .center
        texField.makeBorderLayer(color: .white)
        texField.font = .font(.regular, ofSize: 18)
        texField.returnKeyType = .done
        return texField
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
