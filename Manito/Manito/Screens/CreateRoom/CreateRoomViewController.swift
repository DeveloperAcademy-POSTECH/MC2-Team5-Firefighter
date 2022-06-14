//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class CreateRoomViewController: BaseViewController {
    
    private var index = 0
    
    // MARK: - Property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방 생성하기"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .grey003
        button.setImage(ImageLiterals.icXmark, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: MainButton = {
        let button = MainButton()
        button.title = "다음"
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        button.isDisabled = true
        return button
    }()
    
    private let nameView: InputNameView = {
        let view = InputNameView()
        view.isHidden = false
        return view
        
    }()
    
    private let personView: InputPersonView = {
        let view = InputPersonView()
        view.isHidden = true
        return view
    }()
    
    private let dateView: InputDateView = {
        let view = InputDateView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
    }
    
    override func render() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(57)
            $0.height.equalTo(60)
        }
        
        view.addSubview(nameView)
        nameView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        view.addSubview(personView)
        personView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        view.addSubview(dateView)
        dateView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    // MARK: - Configure
    override func configUI() {
        super.configUI()
        view.backgroundColor = .backgroundGrey
        
        nameView.enableButton = { [weak self] in
            self?.nextButton.isDisabled = false
        }
    }
    
    // MARK: - Selectors
    @objc private func didTapCloseButton() {
        print("ttaapp")
    }
    
    @objc private func didTapNextButton() {
        print("tap")
        index += 1
        changedInputView()
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 60)
            })
        }
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.transform = .identity
        })
    }
    
    // MARK: - Functions
    
    private func changedInputView() {
        if index % 3 == 0 {
            self.nameView.isHidden = false
            self.personView.isHidden = true
            self.dateView.isHidden = true
        }
        else if index % 3 == 1 {
            self.nameView.isHidden = true
            self.personView.isHidden = false
            self.dateView.isHidden = true
        }
        else {
            self.nameView.isHidden = true
            self.personView.isHidden = true
            self.dateView.isHidden = false
        }
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


