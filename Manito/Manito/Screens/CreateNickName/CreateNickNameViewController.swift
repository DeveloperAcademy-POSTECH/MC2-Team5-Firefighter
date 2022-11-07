//
//  CreateNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/12.
//

import UIKit

import SnapKit

class CreateNickNameViewController: BaseViewController {
    
    let settingService: SettingProtocol = SettingAPI(apiService: APIService())
    
    private var nickname: String = ""
    private let maxLength = 5
    
    // MARK: - Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.createNickNameViewControllerTitle
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let roomsNameTextField: UITextField = {
        let textField = UITextField()
        let attributes = [
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        textField.backgroundColor = .darkGrey002
        textField.attributedPlaceholder = NSAttributedString(string: TextLiteral.createNickNameViewControllerAskNickName, attributes:attributes)
        textField.font = .font(.regular, ofSize: 18)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.becomeFirstResponder()
        return textField
    }()
    private lazy var roomsTextLimit : UILabel = {
        let label = UILabel()
        label.text = "0/\(maxLength)"
        label.font = .font(.regular, ofSize: 20)
        label.textColor = .grey002
        return label
    }()
    private lazy var doneButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.done
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.isDisabled = true
        return button
    }()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
        setupNotificationCenter()
    }
    
    // MARK: - API
    func requestNickname(setting: NicknameDTO) {
        Task {
            do {
                let data = try await settingService.putChangeNickname(body: setting)
                if let nickname = data {
                    UserDefaultHandler.setNickname(nickname: nickname)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(message)")
            }
        }
    }
    
    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(roomsNameTextField)
        roomsNameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.equalTo(60)
        }
        
        view.addSubview(roomsTextLimit)
        roomsTextLimit.snp.makeConstraints {
            $0.top.equalTo(roomsNameTextField.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
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
            UserData.setValue(nickname, forKey: .nickname)
            requestNickname(setting: NicknameDTO(nickname: nickname))
            presentMainViewController()
        }
    }
    
    private func presentMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        setCounter(count: textField.text?.count ?? 0)
        checkMaxLength(textField: roomsNameTextField, maxLength: maxLength)
        
        let hasText = roomsNameTextField.hasText
        doneButton.isDisabled = !hasText
    }
}
