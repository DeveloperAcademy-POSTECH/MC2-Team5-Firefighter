//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class DetailWaitViewController: BaseViewController {
    let detailWaitService: DetailWaitProtocol = DetailWaitAPI(apiService: APIService(), environment: .development)
    let userArr = ["호야", "리비", "듀나", "코비", "디너", "케미"]
    var canStartClosure: ((Bool) -> ())?
    var maxUserCount: Int = 10 {
        didSet {
            comeInLabel.text = "\(userCount)/\(maxUserCount)"
        }
    }
    lazy var userCount = userArr.count
    let isOwner = true
    var startDateText = "22.08.11" {
        didSet {
            titleView.dateRangeText = "\(startDateText) ~ \(endDateText)"
        }
    }
    var endDateText = "22.08.15" {
        didSet {
            titleView.dateRangeText = "\(startDateText) ~ \(endDateText)"
        }
    }

    private enum UserStatus: Int, CaseIterable {
        case owner = 0
        case member = 1

        var alertText: AlertText {
            switch self {
            case .owner:
                return .delete
            case .member:
                return .exit
            }
        }
    }

    private enum AlertText {
        case delete
        case exit

        var title: String {
            switch self {
            case .delete:
                return TextLiteral.datailWaitViewControllerDeleteTitle
            case .exit:
                return TextLiteral.datailWaitViewControllerExitTitle
            }
        }

        var message: String {
            switch self {
            case .delete:
                return TextLiteral.datailWaitViewControllerDeleteMessage
            case .exit:
                return TextLiteral.datailWaitViewControllerExitMessage
            }
        }

        var okTitle: String {
            switch self {
            case .delete:
                return TextLiteral.delete
            case .exit:
                return TextLiteral.leave
            }
        }
    }

    private enum ButtonText: String {
        case waiting
        case start
        
        var status: String {
            switch self {
            case .waiting:
                return TextLiteral.datailWaitViewControllerButtonWaitingText
            case .start:
                return TextLiteral.datailWaitViewControllerButtonStartText
            }
        }
    }

    // MARK: - property

    private lazy var settingButton: UIButton = {
        let button = SettingButton()
        button.menu = setExitButtonMenu()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private lazy var titleView: DetailWaitTitleView = {
        let view = DetailWaitTitleView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentDetailEditViewController))
        view.dateRangeText = "\(startDateText) ~ \(endDateText)"
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private let togetherFriendLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.togetherFriend
        label.textColor = .white
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let imgNiView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgNi
        return imageView
    }()
    private lazy var comeInLabel: UILabel = {
        let label = UILabel()
        label.text = "\(userCount)/\(maxUserCount)"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private lazy var copyButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonAction = UIAction { [weak self] _ in
            self?.touchUpToShowToast()
        }
        button.setTitle(TextLiteral.copyCode, for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private let listTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = 10
        table.isScrollEnabled = false
        return table
    }()
    private lazy var startButton: UIButton = {
        let button = MainButton()
        canStartClosure = { value in
            if value {
                button.title = ButtonText.start.status
                button.isDisabled = false
                let action = UIAction { [weak self] _ in
                    let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
                    guard let viewController = storyboard.instantiateViewController(withIdentifier: SelectManittoViewController.className) as? SelectManittoViewController else { return }
                    viewController.modalPresentationStyle = .fullScreen
                    self?.present(viewController, animated: true)
                }
                button.addAction(action, for: .touchUpInside)
            } else {
                button.title = ButtonText.waiting.status
                button.isDisabled = true
            }
        }
        return button
    }()

    // MARK: - life cycle

    deinit {
        print("deInit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidApear 실행")
        requestFriendList()
        requestWaitRoomInfo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
        setupNotificationCenter()
        isPastStartDate()
        setStartButton()
    }

    override func render() {
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.top.equalToSuperview().offset(100)
            $0.height.equalTo(86)
        }

        view.addSubview(togetherFriendLabel)
        togetherFriendLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.top.equalTo(titleView.snp.bottom).offset(44)
        }

        view.addSubview(imgNiView)
        imgNiView.snp.makeConstraints {
            $0.centerY.equalTo(togetherFriendLabel.snp.centerY)
            $0.leading.equalTo(togetherFriendLabel.snp.trailing).offset(7)
            $0.width.height.equalTo(30)
        }

        view.addSubview(comeInLabel)
        comeInLabel.snp.makeConstraints {
            $0.leading.equalTo(imgNiView.snp.trailing)
            $0.centerY.equalTo(imgNiView.snp.centerY)
        }

        view.addSubview(copyButton)
        copyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.centerY.equalTo(togetherFriendLabel.snp.centerY)
        }

        view.addSubview(listTable)
        var tableHeight = userArr.count * 44
        if tableHeight > 400 {
            tableHeight = 400
            listTable.isScrollEnabled = true
        }
        listTable.snp.makeConstraints {
            $0.top.equalTo(togetherFriendLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(tableHeight)
        }

        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(65)
            $0.height.equalTo(60)
        }
    }

    override func configUI() {
        view.backgroundColor = .backgroundGrey
        setupSettingButton()
    }
    
    // MARK: - API
    
    func requestFriendList() {
        Task {
            do {
                let data = try await detailWaitService.getWithFriend(roomId: "1")
                if let friendList = data {
                    print(friendList)
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
    
    func requestWaitRoomInfo() {
        Task {
            do {
                let data = try await
                detailWaitService.getWaitingRoomInfo(roomId: "1")
                if let roomInfo = data {
                    print(roomInfo)
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

    // MARK: - func

    private func setupDelegation() {
        listTable.delegate = self
        listTable.dataSource = self
        listTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = .grey001
        toastLabel.textColor = .black
        toastLabel.font = .font(.regular, ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
        UIView.animate(withDuration: 1.5, animations: {
            toastLabel.alpha = 0.8
        }, completion: { isCompleted in
                UIView.animate(withDuration: 1.5, animations: {
                    toastLabel.alpha = 0
                }, completion: { isCompleted in
                        toastLabel.removeFromSuperview()
                    })
            })
    }

    private func presentModal(from startString: String, to endString: String, isDateEdit: Bool) {
        let viewController = DetailEditViewController(editMode: isDateEdit ? .dateEditMode : .infoEditMode)
        viewController.currentUserCount = userCount
        viewController.sliderValue = maxUserCount
        viewController.startDateText = startString
        viewController.endDateText = endString
        present(viewController, animated: true, completion: nil)
    }

    // MARK: - private func

    private func setupSettingButton() {
        let rightOffsetSettingButton = super.removeBarButtonItemOffset(with: settingButton, offsetX: -10)
        let settingButton = super.makeBarButtonItem(with: rightOffsetSettingButton)

        navigationItem.rightBarButtonItem = settingButton
    }

    private func setExitButtonMenu() -> UIMenu {
        if isOwner {
            let menu = UIMenu(options: [], children: [
                UIAction(title: TextLiteral.modifiedRoomInfo, handler: { [weak self] _ in
                        self?.presentEditRoomView()
                    }),
                UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
                        self?.makeRequestAlert(title: UserStatus.owner.alertText.title, message: UserStatus.owner.alertText.message, okTitle: UserStatus.owner.alertText.okTitle, okAction: nil)
                    })])
            return menu
        } else {
            let menu = UIMenu(options: [], children: [
                UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
                        self?.makeRequestAlert(title: UserStatus.member.alertText.title, message: UserStatus.member.alertText.message, okTitle: UserStatus.member.alertText.okTitle, okAction: nil)
                    })
                ])
            return menu
        }
    }

    private func presentEditRoomView() {
        guard let startDate = startDateText.stringToDate else { return }
        let isAlreadyPastDate = startDate.distance(to: Date()) > 86400
        
        if isAlreadyPastDate {
            editInfoFromDefaultDate()
        } else {
            editInfoFromCurrentDate()
        }
    }
    
    private func editInfoFromDefaultDate() {
        let fiveDaysInterval: TimeInterval = 86400 * 4
        let defaultStartDate = Date().dateToString
        let defaultEndDate = (Date() + fiveDaysInterval).dateToString
        self.presentModal(from: defaultStartDate, to: defaultEndDate, isDateEdit: false)
    }
    
    private func editInfoFromCurrentDate() {
        self.presentModal(from: self.startDateText, to: self.endDateText, isDateEdit: false)
    }

    private func touchUpToShowToast() {
        UIPasteboard.general.string = TextLiteral.detailWaitViewControllerCode
        self.showToast(message: TextLiteral.detailWaitViewControllerCopyCode)
    }

    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDateRange(_:)), name: .dateRangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStartButton), name: .changeStartButtonNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMaxUser), name: .editMaxUserNotification, object: nil)
    }

    private func isPastStartDate() {
        guard let startDate = startDateText.stringToDate else { return }
        let isPast = startDate.distance(to: Date()) > 86400
        let isToday = startDate.distance(to: Date()) < 86400
        let canStart = !isPast && isToday
        if !canStart {
            if isOwner {
                let action: ((UIAlertAction) -> ()) = { [weak self] _ in
                    let fiveDaysInterval: TimeInterval = 86400 * 4
                    let startDate = Date().dateToString
                    let endDate = (Date() + fiveDaysInterval).dateToString
                    self?.presentModal(from: startDate, to: endDate, isDateEdit: true)
                }
                makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle, message: TextLiteral.detailWaitViewControllerPastOwnerAlertMessage, okAction: action)
            } else {
                makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle, message: TextLiteral.detailWaitViewControllerPastAlertMessage)
            }
        }
    }

    private func setStartButton() {
        guard let startDate = startDateText.stringToDate else { return }
        guard let todayDate = Date().dateToString.stringToDate else { return }
        
        let isToday = startDate.distance(to: todayDate).isZero
        
        canStartClosure?(isToday)
    }

    // MARK: - selector

    @objc
    private func didReceiveDateRange(_ notification: Notification) {
        guard let startDate = notification.userInfo?["startDate"] as? String else { return }
        guard let endDate = notification.userInfo?["endDate"] as? String else { return }

        self.startDateText = startDate
        self.endDateText = endDate
    }

    @objc
    private func didReceiveMaxUser(_ notification: Notification) {
        guard let maxUser = notification.userInfo?["maxUser"] as? Float else { return }

        let intMaxUser = Int(maxUser)
        maxUserCount = intMaxUser
    }
    
    @objc
    private func presentDetailEditViewController() {
        self.presentModal(from: self.startDateText, to: self.endDateText, isDateEdit: false)
    }
    
    @objc private func changeStartButton() {
        setStartButton()
    }
}

extension DetailWaitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension DetailWaitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = userArr[indexPath.row]
        cell.textLabel?.font = .font(.regular, ofSize: 17)
        cell.backgroundColor = .darkGrey003
        cell.selectionStyle = .none
        return cell
    }
}
