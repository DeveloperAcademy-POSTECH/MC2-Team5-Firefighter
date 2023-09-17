//
//  InputInvitedCodeView.swift
//  Manito
//
//  Created by 이성호 on 2022/06/15.
//

import Combine
import UIKit

import SnapKit

final class InputInvitedCodeView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private lazy var roomCodeTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        textField.backgroundColor = .darkGrey002
        textField.attributedPlaceholder = NSAttributedString(string: TextLiteral.ParticipateRoom.inputCodePlaceholder.localized(),
                                                             attributes: attributes)
        textField.textAlignment = .center
        textField.makeBorderLayer(color: .white)
        textField.font = .font(.regular, ofSize: 18)
        textField.returnKeyType = .done
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .allCharacters
        textField.becomeFirstResponder()
        return textField
    }()
    private let limitLabel : UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 20)
        label.textColor = .grey002
        return label
    }()
    
    // MARK: - property
    
    let textFieldDidChangedPublisher = PassthroughSubject<String, Never>()
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    func setupLayout() {
        self.addSubview(self.roomCodeTextField)
        self.roomCodeTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        self.addSubview(self.limitLabel)
        self.limitLabel.snp.makeConstraints {
            $0.top.equalTo(self.roomCodeTextField.snp.bottom).offset(10)
            $0.trailing.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }
    
    func code() -> String {
        guard let code = self.roomCodeTextField.text else { return "" }
        return code
    }
    
    func updateTextCount(count: Int, maxLength: Int) {
        self.limitLabel.text = "\(count)/\(maxLength)"
    }
    
    func updateTextFieldText(fixedText: String) {
        DispatchQueue.main.async {
            self.roomCodeTextField.text = String(fixedText)
        }
    }
}

extension InputInvitedCodeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomCodeTextField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.textFieldDidChangedPublisher.send(textField.text ?? "")
    }
}
