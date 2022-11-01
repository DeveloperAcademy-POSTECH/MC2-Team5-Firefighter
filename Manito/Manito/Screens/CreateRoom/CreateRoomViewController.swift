//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class CreateRoomViewController: BaseViewController {
    let roomService: RoomProtocol = RoomAPI(apiService: APIService())
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
    private var roomInfo: RoomDTO?
    
    // MARK: - Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.createRoom
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
        button.title = TextLiteral.next
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        button.isDisabled = true
        return button
    }()
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.icBack, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setTitle(" " + TextLiteral.previous, for: .normal)
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
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButton()
        setupNotificationCenter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleLabel.becomeFirstResponder()
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(23)
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
        
        view.bringSubviewToFront(nextButton)
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
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
            checkView.name = text
            notiIndex = .inputPerson
            changedInputView()
            nameView.roomsNameTextField.resignFirstResponder()
        case .inputPerson:
            person = Int(personView.personSlider.value)
            checkView.person = person
            notiIndex = .inputDate
            changedInputView()
        case .inputDate:
            notiIndex = .checkRoom
            checkView.dateRange = "\(dateView.calendarView.getTempStartDate()) ~ \(dateView.calendarView.getTempEndDate())"
            changedInputView()
        case .checkRoom:
            roomInfo = RoomDTO(title: name, capacity: person, startDate: "20\(dateView.calendarView.getTempStartDate())", endDate: "20\(dateView.calendarView.getTempEndDate())")
            let chooseVC = ChooseCharacterViewController(statusMode: .createRoom, roomId: nil)
            chooseVC.roomInfo = roomInfo
            navigationController?.pushViewController(chooseVC, animated: true)
        }
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2, animations: {
                self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 30)
            })
        }
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.transform = .identity
        })
    }
    
    override func endEditingView() {
        if !nextButton.isTouchInside {
            view.endEditing(true)
        }
    }
    
    // MARK: - Functions
    
    private func toggleButton() {
        nameView.changeNextButtonEnableStatus = { [weak self] isEnable in
            self?.nextButton.isDisabled = !isEnable
        }
        
        dateView.calendarView.changeButtonState = { [weak self] isEnabled in
            self?.nextButton.isDisabled = !isEnabled
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
            nextButton.isDisabled = false
            UIView.animate(withDuration: 0.3) {
                self.nameView.alpha = 0.0
                self.personView.alpha = 1.0
                self.dateView.alpha = 0.0
                self.backButton.isHidden = false
            }
        case RoomState.inputDate:
            dateView.calendarView.setupButtonState()
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
