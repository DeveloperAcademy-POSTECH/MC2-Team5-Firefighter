//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class CreateRoomViewController: BaseViewController {
            
    // MARK: - ui component
    
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
        view.isHidden = true
        return view
    }()
    private let dateView: InputDateView = {
        let view = InputDateView()
        view.alpha = 0.0
        view.isHidden = true
        return view
    }()
    private let checkView: CheckRoomView = {
        let view = CheckRoomView()
        view.alpha = 0.0
        view.isHidden = true
        return view
    }()
    
    // MARK: - property
    
    let roomService: RoomProtocol = RoomAPI(apiService: APIService())
    private var name: String = ""
    private var person: Int = 0
    private var notiIndex: RoomState = .inputName
    private var roomInfo: RoomDTO?
    private enum RoomState: Int {
        case inputName = 0
        case inputPerson = 1
        case inputDate = 2
        case checkRoom = 3
    }
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButton()
        setupNotificationCenter()
    }
        
    override func setupLayout() {
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
    
    override func configureUI() {
        super.configureUI()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - selector
    
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
            setDataInCheckView(name: name)
            changeNotiIndex()
            changedInputView()
            nameView.roomsNameTextField.resignFirstResponder()
        case .inputPerson:
            person = Int(personView.personSlider.value)
            setDataInCheckView(person: person)
            changeNotiIndex()
            changedInputView()
        case .inputDate:
            setDataInCheckView(date: "\(dateView.calendarView.getTempStartDate()) ~ \(dateView.calendarView.getTempEndDate())")
            changeNotiIndex()
            changedInputView()
        case .checkRoom:
            roomInfo = RoomDTO(title: name,
                               capacity: person,
                               startDate: "20\(dateView.calendarView.getTempStartDate())",
                               endDate: "20\(dateView.calendarView.getTempEndDate())")
            let viewController = ChooseCharacterViewController(statusMode: .createRoom, roomId: nil)
            viewController.roomInfo = roomInfo
            navigationController?.pushViewController(viewController, animated: true)
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
    
    // MARK: - func
    
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
        case .inputName:
            setInputNameView()
        case .inputPerson:
            setInputPersonView()
        case .inputDate:
            setInputDateView()
        case .checkRoom:
            setCheckRoomView()
        }
    }
    
    private func setInputNameView() {
        self.backButton.isHidden = true
        self.nameView.fadeIn()
        self.nameView.isHidden = false
        self.personView.fadeOut()
        self.personView.isHidden = true
    }
    
    private func setInputPersonView() {
        self.nextButton.isDisabled = false
        self.backButton.isHidden = false
        self.nameView.fadeOut()
        self.nameView.isHidden = true
        self.personView.fadeIn()
        self.personView.isHidden = false
        self.dateView.fadeOut()
        self.dateView.isHidden = true
    }
    
    private func setInputDateView() {
        dateView.calendarView.setupButtonState()
        self.personView.fadeOut()
        self.personView.isHidden = true
        self.dateView.fadeIn()
        self.dateView.isHidden = false
        self.checkView.fadeOut()
        self.checkView.isHidden = true
    }
    
    private func setCheckRoomView() {
        self.dateView.fadeOut()
        self.dateView.isHidden = true
        self.checkView.fadeIn()
        self.checkView.isHidden = false
    }
    
    private func setDataInCheckView(name: String = "", person: Int = 0, date: String = "" ) {
        switch notiIndex {
        case .inputName:
            checkView.name = name
        case .inputPerson:
            checkView.person = person
        case .inputDate:
            checkView.dateRange = date
        default:
            return
        }
    }
    private func changeNotiIndex() {
        switch notiIndex {
        case .inputName:
            notiIndex = .inputPerson
        case .inputPerson:
            notiIndex = .inputDate
        case .inputDate:
            notiIndex = .checkRoom
        default:
            return
        }
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension UIView {
    func fadeIn(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        }
    }
}
