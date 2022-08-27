//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class CreateRoomViewController: BaseViewController {
    
    private var name = ""
    private var person = 0
    private var date = 0
    
    private enum RoomState: Int {
        case inputName = 0
        case inputPerson = 1
        case inputDate = 2
        case checkRoom = 3
    }
    
    private var notiIndex: RoomState = .inputName
    
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
        let button = UIButton()
        button.setImage(ImageLiterals.icBack, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setTitle(" 이전", for: .normal)
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
    private let dateView: InputDateView = {
        let view = InputDateView()
        view.alpha = 0.0
        return view
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
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(closeButton)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(57)
            $0.height.equalTo(60)
        }
        
        view.addSubview(nameView)
        nameView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        view.addSubview(personView)
        personView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        view.addSubview(dateView)
        dateView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        view.addSubview(checkView)
        checkView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
        view.backgroundColor = .backgroundGrey
        toggleButton()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Selectors
    
    @objc private func didTapBackButton() {
        notiIndex = RoomState.init(rawValue: notiIndex.rawValue - 1) ?? RoomState.inputName
        changedInputView()
    }
    
    @objc private func didTapCloseButton() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func didTapNextButton() {
        switch notiIndex {
        case .inputName:
            guard let text = nameView.roomsNameTextField.text else { return }
            name = text
            notiIndex = .inputPerson
            checkView.name = text
            changedInputView()
        case .inputPerson:
            person = Int(personView.personSlider.value)
            notiIndex = .inputDate
            checkView.person = person
            changedInputView()
        case .inputDate:
            notiIndex = .checkRoom
            checkView.dateRange = "\(dateView.calendarView.getTempStartDate()) ~ \(dateView.calendarView.getTempEndDate())"
            changedInputView()
        case .checkRoom:
            print("여기는 끝^__^")
        }
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
    
    private func toggleButton() {
        nameView.changeNextButtonEnableStatus = { [weak self] isEnable in
            self?.nextButton.isDisabled = !isEnable
        }
    }
    
    private func changedInputView() {
        switch notiIndex {
        case RoomState.inputName:
            UIView.animate(withDuration: 0.3) {
                self.nameView.alpha = 1.0
                self.personView.alpha = 0.0
                self.backButton.isHidden = true
            }
        case RoomState.inputPerson:
            UIView.animate(withDuration: 0.3) {
                self.nameView.alpha = 0.0
                self.personView.alpha = 1.0
                self.dateView.alpha = 0.0
                self.backButton.isHidden = false
            }
        case RoomState.inputDate:
            UIView.animate(withDuration: 0.3) {
                self.personView.alpha = 0.0
                self.dateView.alpha = 1.0
                self.checkView.alpha = 0.0
            }
        case RoomState.checkRoom:
            UIView.animate(withDuration: 0.3) {
                self.dateView.alpha = 0.0
                self.checkView.alpha = 1.0
            }
        }
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
