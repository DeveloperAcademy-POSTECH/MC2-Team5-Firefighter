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
    private var detectStartableStatus: ((Bool) -> ())?
    private var memberType = UserStatus.member {
        didSet {
            settingButton.menu = setExitButtonMenu()
            setupTitleViewGesture()
        }
    }

    private enum UserStatus: CaseIterable {
        case owner
        case member

        var alertText: (title: String, message: String, okTitle: String) {
            switch self {
            case .owner:
                return (title: TextLiteral.datailWaitViewControllerDeleteTitle,
                        message: TextLiteral.datailWaitViewControllerDeleteMessage,
                        okTitle: TextLiteral.delete)
            case .member:
                return (title: TextLiteral.datailWaitViewControllerExitTitle,
                        message: TextLiteral.datailWaitViewControllerExitMessage,
                        okTitle: TextLiteral.leave)
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
        detectStartableStatus = { value in
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
                          let participants = roomInfo.participants,
                          let isAdmin = roomInfo.admin else { return }
                    self.room = roomInfo
                    userArr = participants.membersNickname
                    memberType = isAdmin ? .owner : .member
                    self.roomInfo = roomInfo.roomDTO
                    setStartButton()
                    DispatchQueue.main.async {
                        self.isPastStartDate()
                        self.titleView.setStartState(state: state)
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

    private func presentDetailEditViewController(startString: String, endString: String, isDateEdit: Bool) {
        guard let title = titleView.roomTitleLabel.text else { return }
        let viewController = DetailEditViewController(editMode: isDateEdit ? .date : .information,
                                                      roomIndex: roomIndex,
                                                      title: title)
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
        let children: [UIAction] = memberType == .owner
        ? [UIAction(title: TextLiteral.modifiedRoomInfo, handler: { [weak self] _ in
            self?.presentEditRoomView()
        }),UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
               self?.makeRequestAlert(title: UserStatus.owner.alertText.title, message: UserStatus.owner.alertText.message, okTitle: UserStatus.owner.alertText.okTitle, okAction: { _ in
                   self?.requestDeleteRoom()
               })
           })
        ]
        : [UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
            self?.makeRequestAlert(title: UserStatus.member.alertText.title, message: UserStatus.member.alertText.message, okTitle: UserStatus.member.alertText.okTitle, okAction:  { _ in
                self?.requestDeleteLeaveRoom()
            })
        })]
        let menu = UIMenu(children: children)
        return menu
    }

    private func presentEditRoomView() {
        guard let roomInformation = room?.roomInformation else { return }
        if roomInformation.isAlreadyPastDate {
            editInfoFromDefaultDate()
        } else {
            editInfoFromCurrentDate()
        }
    }
    
    private func editInfoFromDefaultDate() {
        let fiveDaysInterval: TimeInterval = 86400 * 4
        let defaultStartDate = Date().dateToString
        let defaultEndDate = (Date() + fiveDaysInterval).dateToString
        self.presentDetailEditViewController(startString: defaultStartDate, endString: defaultEndDate, isDateEdit: false)
    }
    
    private func editInfoFromCurrentDate() {
        guard let startDate = room?.roomInformation?.startDate,
              let endDate = room?.roomInformation?.endDate else { return }
        self.presentDetailEditViewController(startString: startDate, endString: endDate, isDateEdit: false)
    }

    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didTapEnterButton), name: .createRoomInvitedCode, object: nil)
    }

    private func isPastStartDate() {
        guard let isStart = room?.roomInformation?.isStart else { return }
        if !isStart {
            switch memberType {
            case .owner:
                let action: ((UIAlertAction) -> ()) = { [weak self] _ in
                    let fiveDaysInterval: TimeInterval = 86400 * 4
                    let startDate = Date().dateToString
                    let endDate = (Date() + fiveDaysInterval).dateToString
                    self?.presentDetailEditViewController(startString: startDate, endString: endDate, isDateEdit: true)
                }
                makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle, message: TextLiteral.detailWaitViewControllerPastOwnerAlertMessage, okAction: action)
            case .member:
                makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle, message: TextLiteral.detailWaitViewControllerPastAlertMessage)
            }
        }
    }

    private func setStartButton() {
        if memberType == .owner {
            guard let canStart = room?.canStart else { return }
            detectStartableStatus?(canStart)
        } else {
            detectStartableStatus?(false)
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
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentEditViewController))
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
    
    @objc private func presentEditViewController() {
        guard let startDate = room?.roomInformation?.startDate,
              let endDate = room?.roomInformation?.endDate else { return }
        self.presentDetailEditViewController(startString: startDate, endString: endDate, isDateEdit: false)
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
