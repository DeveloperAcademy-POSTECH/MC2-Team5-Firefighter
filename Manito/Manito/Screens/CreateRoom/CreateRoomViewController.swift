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
    private var name = ""
    private var person = 0
    private var date = 0
    
    // MARK: - Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방 생성하기"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        button.tintColor = .grey001
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
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(ImageLiterals.icBack, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 14)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    private let nameView = InputNameView()
    private let personView: InputPersonView = {
        let view = InputPersonView()
        view.alpha = 0.0
        return view
    }()
    private let dateView: CalendarView = {
        let view = CalendarView()
        view.alpha = 0.0
        return view
    }()
    private let checkLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 7일까지 설정할 수 있어요 !"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .grey002
        label.alpha = 0.0
        return label
    }()
    private let checkView: CheckRoomView = {
        let view = CheckRoomView()
        view.alpha = 0.0
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
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(closeButton)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
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
            $0.height.equalTo(420)
        }
        
        view.addSubview(checkLabel)
        checkLabel.snp.makeConstraints {
            $0.top.equalTo(dateView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(16)
        }
    
        view.addSubview(checkView)
        checkView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
        view.backgroundColor = .backgroundGrey
        toggleButton()
    }
    
    // MARK: - Selectors
    
    @objc private func didTapBackButton() {
        index = index - 1
        changedInputView()
    }
    
    @objc private func didTapCloseButton() {
        print("didTapCloseButton")
    }
    
    @objc private func didTapNextButton() {
        switch index {
        case 0:
            guard let text = nameView.roomsNameTextField.text else { return }
            name = text
        case 1:
            person = Int(personView.personSlider.value)
        case 2:
            print("기간 선택 보여주기")
        default:
            print("다른 뷰 넘기기")
        }
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
    
    @objc private func didReceiveNameNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.nameView.alpha = 1.0
            self.personView.alpha = 0.0
            self.backButton.isHidden = true
        }
    }
    
    @objc private func didReceivePersonNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.nameView.alpha = 0.0
            self.personView.alpha = 1.0
            self.dateView.alpha = 0.0
            self.checkLabel.alpha = 0.0
            self.backButton.isHidden = false
        }
    }
    
    @objc private func didReceiveDateNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.personView.alpha = 0.0
            self.dateView.alpha = 1.0
            self.checkLabel.alpha = 1.0
            self.checkView.alpha = 0.0
        }
    }
    
    @objc private func didReceiveCheckNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.dateView.alpha = 0.0
            self.checkLabel.alpha = 0.0
            self.checkView.alpha = 1.0
        }
    }
    
    // MARK: - Functions
    
    private func toggleButton() {
        nameView.enableButton = { [weak self] in
            self?.nextButton.isDisabled = false
        }
    }
    
    private func changedInputView() {
        if index == 0 {
            NotificationCenter.default.post(name: .nameNotification, object: nil)
        }
        else if index == 1 {
            NotificationCenter.default.post(name: .personNotification, object: nil)
        }
        else if index == 2 {
            NotificationCenter.default.post(name: .dateNotification, object: nil)
        }
        else {
            NotificationCenter.default.post(name: .checkNotification, object: nil)
        }
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNameNotification(_ :)), name: .nameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePersonNotification(_ :)), name: .personNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDateNotification(_ :)), name: .dateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCheckNotification(_ :)), name: .checkNotification, object: nil)
    }
}
