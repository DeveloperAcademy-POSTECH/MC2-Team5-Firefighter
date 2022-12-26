//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class DetailWaitViewController: BaseViewController {
    let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    var roomIndex: Int
    var roomInformation: ParticipatingRoom?
    var inviteCode: String = ""
    private var roomInfo: RoomDTO?
    private var userArr: [String] = [] {
        didSet {
            renderTableView()
        }
    }
    var canStartClosure: ((Bool) -> ())?
    var maxUserCount: Int = 15 {
        didSet {
            comeInLabel.text = "\(userCount)/\(maxUserCount)"
        }
    }
    lazy var userCount = 0 {
        didSet {
            comeInLabel.text = "\(userCount)/\(maxUserCount)"
            setStartButton()
        }
    }
    var memberType = UserStatus.member {
        didSet {
            settingButton.menu = setExitButtonMenu()
            setupTitleViewGesture()
        }
    }
    var startDateText = "" {
        didSet {
            titleView.dateRangeText = "\(startDateText) ~ \(endDateText)"
        }
    }
    var endDateText = "" {
        didSet {
            titleView.dateRangeText = "\(startDateText) ~ \(endDateText)"
        }
    }

    enum UserStatus: CaseIterable {
        case owner
        case member

        var alertText: AlertText {
            switch self {
            case .owner:
                return .delete
            case .member:
                return .exit
            }
        }
    }

    enum AlertText {
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
        let button = MoreButton()
        button.menu = setExitButtonMenu()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private lazy var titleView: DetailWaitTitleView = {
        let view = DetailWaitTitleView()
        view.dateRangeText = "\(startDateText) ~ \(endDateText)"
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
                    print("detailwait self?.roomInformation", self?.roomInformation)
                    self?.requestStartManitto()
                }
                button.addAction(action, for: .touchUpInside)
            } else {
                button.title = ButtonText.waiting.status
                button.isDisabled = true
            }
        }
        return button
    }()

    // MARK: - init
    
    init(index: Int) {
        roomIndex = index
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestWaitRoomInfo()
        setupDelegation()
        setupNotificationCenter()
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

        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(65)
            $0.height.equalTo(60)
        }
    }

    override func configUI() {
        super.configUI()
        setupSettingButton()
    }
    
    // MARK: - API
    
    func requestWaitRoomInfo() {
        Task {
            do {
                let data = try await detailWaitService.getWaitingRoomInfo(roomId: "\(roomIndex)")
                if let roomInfo = data {
                    guard let title = roomInfo.room?.title,
                          let code = roomInfo.invitation?.code,
                          let startDate = roomInfo.room?.startDate,
                          let endDate = roomInfo.room?.endDate,
                          let count = roomInfo.participants?.count,
                          let capacity = roomInfo.room?.capacity,
                          let state = roomInfo.room?.state,
                          let members = roomInfo.participants?.members,
                          let isAdmin = roomInfo.admin else { return }
                    titleView.roomTitleLabel.text = title
                    inviteCode = code
                    startDateText = startDate
                    endDateText = endDate
                    userCount = count
                    maxUserCount = capacity
                    titleView.setStartState(state: state)
                    userArr = members.map { $0.nickname ?? "" }
                    memberType = isAdmin ? .owner : .member
                    self.roomInfo = RoomDTO(title: title,
                                            capacity: capacity,
                                            startDate: startDate,
                                            endDate: endDate)
                    isPastStartDate()
                    setStartButton()
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    func requestChangeRoomInfo(roomDto: RoomDTO) {
        Task {
            do {
                let status = try await detailWaitService.editRoomInfo(roomId: "\(roomIndex)", roomInfo: roomDto)
                if status == 204 {
                    showToast(message: "방 정보 수정 완료")
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    func requestStartManitto() {
        Task {
            do {
                let data = try await detailWaitService.startManitto(roomId: "\(roomIndex)")
                if let manittee = data {
                    let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
                    guard let viewController = storyboard.instantiateViewController(withIdentifier: SelectManittoViewController.className) as? SelectManittoViewController else { return }
                    guard let nickname = manittee.nickname else { return }
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.manitteeName = nickname
                    viewController.roomId = roomInformation?.id?.description
                    present(viewController, animated: true)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    func requestDeleteRoom() {
        Task {
            do {
                let status = try await detailWaitService.deleteRoom(roomId: "\(roomIndex)")
                if status == 204 {
                    navigationController?.popViewController(animated: true)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    func requestDeleteLeaveRoom() {
        Task {
            do {
                let status = try await detailWaitService.deleteLeaveRoom(roomId: "\(roomIndex)")
                if status == 204 {
                    navigationController?.popViewController(animated: true)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
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
        UIView.animate(withDuration: 0.7, animations: {
            toastLabel.alpha = 0.8
        }, completion: { isCompleted in
            UIView.animate(withDuration: 0.7, delay: 0.5, animations: {
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
        switch memberType {
        case .owner:
            let menu = UIMenu(options: [], children: [
                UIAction(title: TextLiteral.modifiedRoomInfo, handler: { [weak self] _ in
                    self?.presentEditRoomView()
                }),
                UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
                    self?.makeRequestAlert(title: UserStatus.owner.alertText.title, message: UserStatus.owner.alertText.message, okTitle: UserStatus.owner.alertText.okTitle, okAction: { _ in
                        self?.requestDeleteRoom()
                    })
                })])
            return menu
        case .member:
            let menu = UIMenu(options: [], children: [
                UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
                    self?.makeRequestAlert(title: UserStatus.member.alertText.title, message: UserStatus.member.alertText.message, okTitle: UserStatus.member.alertText.okTitle, okAction:  { _ in
                        self?.requestDeleteLeaveRoom()
                    })
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
        UIPasteboard.general.string = inviteCode
        self.showToast(message: TextLiteral.detailWaitViewControllerCopyCode)
    }

    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDateRange(_:)), name: .dateRangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStartButton), name: .changeStartButtonNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMaxUser), name: .editMaxUserNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestDateRange(_:)), name: .requestDateRangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestRoomInfo(_:)), name: .requestRoomInfoNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTapEnterButton), name: .createRoomInvitedCode, object: nil)
    }

    private func isPastStartDate() {
        guard let startDate = startDateText.stringToDate else { return }
        let isPast = startDate.distance(to: Date()) > 86400
        let isToday = startDate.distance(to: Date()) < 86400
        let canStart = !isPast && isToday
        if !canStart {
            switch memberType {
            case .owner:
                let action: ((UIAlertAction) -> ()) = { [weak self] _ in
                    let fiveDaysInterval: TimeInterval = 86400 * 4
                    let startDate = Date().dateToString
                    let endDate = (Date() + fiveDaysInterval).dateToString
                    self?.presentModal(from: startDate, to: endDate, isDateEdit: true)
                }
                makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle, message: TextLiteral.detailWaitViewControllerPastOwnerAlertMessage, okAction: action)
            case .member:
                makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle, message: TextLiteral.detailWaitViewControllerPastAlertMessage)
            }
        }
    }

    private func setStartButton() {
        if memberType == .owner {
            guard let startDate = startDateText.stringToDate else { return }
            guard let todayDate = Date().dateToString.stringToDate else { return }
            
            let isToday = startDate.distance(to: todayDate).isZero
            let isMinimumUserCount = userCount >= 5
            
            canStartClosure?(isToday && isMinimumUserCount)
        } else {
            canStartClosure?(false)
        }
    }
    
    private func renderTableView() {
        DispatchQueue.main.async {
            self.listTable.reloadData()
            self.view.addSubview(self.listTable)
            var tableHeight = self.userArr.count * 44
            if tableHeight > 400 {
                tableHeight = 400
                self.listTable.isScrollEnabled = true
            }
            self.listTable.snp.makeConstraints {
                $0.top.equalTo(self.togetherFriendLabel.snp.bottom).offset(30)
                $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(tableHeight)
            }
        }
    }
    
    private func setupTitleViewGesture() {
        if memberType == .owner {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentDetailEditViewController))
            titleView.addGestureRecognizer(tapGesture)
        }
    }

    // MARK: - selector
    @objc
    private func didTapEnterButton() {
        guard let roomInfo = roomInfo else { return }
        let viewController = InvitedCodeViewController(roomInfo: RoomDTO(title: roomInfo.title,
                                                             capacity: roomInfo.capacity,
                                                             startDate: roomInfo.startDate,
                                                             endDate: roomInfo.endDate), code: inviteCode)
        viewController.roomInfo = roomInfo
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }

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
    
    @objc private func requestDateRange(_ notification: Notification) {
        guard let startDate = notification.userInfo?["startDate"] as? String else { return }
        guard let endDate = notification.userInfo?["endDate"] as? String else { return }
        requestChangeRoomInfo(roomDto: RoomDTO(title: titleView.roomTitleLabel.text ?? "", capacity: maxUserCount, startDate: startDate, endDate: endDate))
    }
    
    @objc private func requestRoomInfo(_ notification: Notification) {
        guard let startDate = notification.userInfo?["startDate"] as? String else { return }
        guard let endDate = notification.userInfo?["endDate"] as? String else { return }
        guard let capacity = notification.userInfo?["maxUser"] as? Int else { return }
        requestChangeRoomInfo(roomDto: RoomDTO(title: titleView.roomTitleLabel.text ?? "", capacity: capacity, startDate: startDate, endDate: endDate))
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
