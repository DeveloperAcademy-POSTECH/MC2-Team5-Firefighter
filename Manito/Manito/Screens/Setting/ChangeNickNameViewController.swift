//
//  ChangeNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/09/05.
//

import UIKit

class ChangeNickNameViewController: BaseViewController {
    
    private var nickname: String = "호야"
    
    // MARK: - Property
    private lazy var roomsNameTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        textField.backgroundColor = .darkGrey002
        textField.attributedPlaceholder = NSAttributedString(string: TextLiteral.createNickNameViewControllerAskNickName, attributes:attributes)
        textField.font = .font(.regular, ofSize: 18)
        textField.text = nickname
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.textAlignment = .center
        textField.returnKeyType = .done
        return textField
    }()
    private lazy var doneButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.done
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.isDisabled = true
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
        setupNotificationCenter()
    }
    
    override func render() {
        view.addSubview(roomsNameTextField)
        roomsNameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo(60)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(23)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Seletors
    
    @objc private func didTapDoneButton() {
        if let text = roomsNameTextField.text, !text.isEmpty {
            nickname = text
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.doneButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 30)
            })
        }
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.doneButton.transform = .identity
        })
    }
    
    override func endEditingView() {
        if !doneButton.isTouchInside {
            view.endEditing(true)
        }
    }
    
    // MARK: - Funtions
    
    private func setupDelegation() {
        roomsNameTextField.delegate = self
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
        title = TextLiteral.changeNickNameViewControllerTitle
    }
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Extension
extension ChangeNickNameViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            roomsNameTextField.resignFirstResponder()
            return true
        }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        doneButton.isDisabled = !textField.hasText
    }
}
