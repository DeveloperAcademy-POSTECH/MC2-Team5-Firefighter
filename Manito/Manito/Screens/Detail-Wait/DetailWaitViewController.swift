//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class DetailWaitViewController: BaseViewController {
    private var room: Room?
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    private let roomIndex: Int
    var roomInformation: ParticipatingRoom?
    private var roomInfo: RoomDTO?
    private var userArr: [String] = [] {
        didSet {
            renderTableView()
        }
    }
    private var canStartManitto: ((Bool) -> ())?
    private var memberType = UserStatus.member {
        didSet {
            settingButton.menu = setExitButtonMenu()
            setupTitleViewGesture()
        }
    }

    private enum UserStatus: CaseIterable {
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
        let button = MoreButton()
        button.menu = setExitButtonMenu()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private let titleView = DetailWaitTitleView()
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
        label.textColor = .white
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private lazy var copyButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonAction = UIAction { [weak self] _ in
            if let code = self?.room?.invitation?.code {
                ToastView.showToast(code: code ,message: TextLiteral.detailWaitViewControllerCopyCode, controller: self ?? UIViewController())
            }
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
        canStartManitto = { value in
            if value {
                button.title = ButtonText.start.status
                button.isDisabled = false
                let action = UIAction { [weak self] _ in
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
    
    private func requestWaitRoomInfo() {
        Task {
            do {
                let data = try await detailWaitService.getWaitingRoomInfo(roomId: "\(roomIndex)")
                if let roomInfo = data {
                    guard let title = roomInfo.roomInformation?.title,
                          let state = roomInfo.roomInformation?.state,
                          let members = roomInfo.participants?.members,
                          let isAdmin = roomInfo.admin else { return }
                    self.room = data
                    titleView.setStartState(state: state)
                    userArr = members.map { $0.nickname ?? "" }
                    memberType = isAdmin ? .owner : .member
                    self.roomInfo = RoomDTO(title: title,
                                            capacity: data?.roomInformation?.capacity ?? 15,
                                            startDate: data?.roomInformation?.startDate ?? "",
                                            endDate: data?.roomInformation?.endDate ?? "")
                    isPastStartDate()
                    setStartButton()
                    DispatchQueue.main.async {
                        self.comeInLabel.text = data?.userCount
                        self.titleView.setRoomTitleLabelText(text: title)
                        self.titleView.setDurationDateLabel(text: roomInfo.roomInformation?.dateRange ?? "")
                    }
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
    
    private func requestStartManitto() {
        Task {
            do {
                let data = try await detailWaitService.startManitto(roomId: "\(roomIndex)")
                if let manittee = data {
                    let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
                    guard let viewController = storyboard.instantiateViewController(withIdentifier: SelectManittoViewController.className) as? SelectManittoViewController else { return }
                    guard let nickname = manittee.nickname else { return }
                    viewController.modalPresentationStyle = .fullScreen
                    viewController.manitteeName = nickname
                    viewController.roomInformation = roomInformation
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
    
    private func requestDeleteRoom() {
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
    
    private func requestDeleteLeaveRoom() {
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

    private func presentModal(from startString: String, to endString: String, isDateEdit: Bool) {
        let viewController = DetailEditViewController(editMode: isDateEdit ? .dateEditMode : .infoEditMode,
                                                      roomIndex: roomIndex,
                                                      title: titleView.getRoomTitleLabelText())
        viewController.didTappedChangeButton = { [weak self] in
            self?.requestWaitRoomInfo()
        }
        guard let userCount = room?.participants?.count,
              let capacity = room?.roomInformation?.capacity else { return }
        viewController.currentUserCount = userCount
        viewController.sliderValue = capacity
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
        guard let startDate = room?.roomInformation?.startDate?.stringToDate else { return }
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
        guard let startDate = room?.roomInformation?.startDate,
              let endDate = room?.roomInformation?.endDate else { return }
        self.presentModal(from: startDate, to: endDate, isDateEdit: false)
    }

    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didTapEnterButton), name: .createRoomInvitedCode, object: nil)
    }

    private func isPastStartDate() {
        guard let startDate = room?.roomInformation?.startDate?.stringToDate else { return }
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
            guard let startDate = room?.roomInformation?.startDate?.stringToDate,
                  let todayDate = Date().dateToString.stringToDate,
                  let userCount = room?.participants?.count else { return }
            
            let isToday = startDate.distance(to: todayDate).isZero
            let isMinimumUserCount = userCount >= 4
            
            canStartManitto?(isToday && isMinimumUserCount)
        } else {
            canStartManitto?(false)
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
    @objc private func didTapEnterButton() {
        guard let roomInfo = roomInfo,
              let code = room?.invitation?.code
        else { return }
        let viewController = InvitedCodeViewController(roomInfo: RoomDTO(title: roomInfo.title,
                                                             capacity: roomInfo.capacity,
                                                             startDate: roomInfo.startDate,
                                                             endDate: roomInfo.endDate),
                                                       code: code)
        viewController.roomInfo = roomInfo
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
    
    @objc private func presentDetailEditViewController() {
        guard let startDate = room?.roomInformation?.startDate,
              let endDate = room?.roomInformation?.endDate else { return }
        self.presentModal(from: startDate, to: endDate, isDateEdit: false)
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
