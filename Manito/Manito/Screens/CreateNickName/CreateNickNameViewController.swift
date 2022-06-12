//
//  CreateNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/12.
//

import UIKit

import SnapKit

class CreateNickNameViewController: BaseViewController {
    
    private var nickName: String = ""
    
    // MARK: - Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 설정"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let roomsNameTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        textField.backgroundColor = .subBackgroundGrey
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임을 적어주세요", attributes:attributes)
        textField.font = .font(.regular, ofSize: 18)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.becomeFirstResponder()
        return textField
    }()
    lazy var doneButton : MainButton = {
        let button = MainButton()
        button.title = "완료"
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.isDisabled = true
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
    }
    
    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(roomsNameTextField)
        roomsNameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(60)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(23)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Seletors
    
    @objc func didTapDoneButton() {
        if let text = roomsNameTextField.text, !text.isEmpty {
            nickName = text
        }
        roomsNameTextField.resignFirstResponder()
    }
    
    // MARK: - Funtions
    
    func setupDelegation() {
        roomsNameTextField.delegate = self
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
    }
}

// MARK: - Extension
extension CreateNickNameViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomsNameTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && range.length != 0 {
            doneButton.isDisabled = true
        }
        else {
            doneButton.isDisabled = false
        }
        return true
    }
}
