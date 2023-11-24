//
//  InputNameView.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/11.
//

import Combine
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
        textField.attributedPlaceholder = NSAttributedString(string: TextLiteral.CreateRoom.inputNameTitle.localized(),
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
    private let roomsTextLimitLabel : UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 20)
        label.textColor = .grey002
        return label
    }()
    
    // MARK: - property
    
    let textFieldPublisher: PassthroughSubject<String, Never> = PassthroughSubject()
    
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
    
    func updateTextFieldText(fixedTitle: String) {
        DispatchQueue.main.async {
            self.roomsNameTextField.text = String(fixedTitle)
        }
    }
    
    func updateTitleCount(count: Int, maxLength: Int) {
        self.roomsTextLimitLabel.text = "\(count)/\(maxLength)"
    }
}

extension InputTitleView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.textFieldPublisher.send(textField.text ?? "")
    }
}
