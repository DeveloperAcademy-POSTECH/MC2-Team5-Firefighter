//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class DetailWaitViewController: BaseViewController {

    private enum UserStatus: CaseIterable {
        case owner
        case member

        var alertText: (title: String,
                        message: String,
                        okTitle: String) {
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

    // MARK: - ui component

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
    private let comeInLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private lazy var copyButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonAction = UIAction { [weak self] _ in
            if let code = self?.room?.invitation?.code {
                ToastView.showToast(code: code ,
                                    message: TextLiteral.detailWaitViewControllerCopyCode,
                                    controller: self ?? UIViewController())
            }
        }
        button.setTitle(TextLiteral.copyCode, for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false
        return tableView
    }()
    private lazy var startButton: UIButton = {
        let button = MainButton()
        self.detectStartableStatus = { value in
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
    
    // MARK: - property
    
    private var room: Room?
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    private let roomIndex: Int
    var roomInformation: ParticipatingRoom?
    private var roomInfo: RoomDTO?
    private var userArr: [String] = [] {
        didSet {
            self.renderTableView()
        }
    }
    private var detectStartableStatus: ((Bool) -> ())?
    private var memberType = UserStatus.member {
        didSet {
            self.settingButton.menu = self.setExitButtonMenu()
            self.setupTitleViewGesture()
        }
    }

    // MARK: - init
    
    init(index: Int) {
        self.roomIndex = index
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
        self.requestWaitRoomInfo()
        self.setupDelegation()
        self.setupNotificationCenter()
    }

    override func setupLayout() {
        self.view.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.top.equalToSuperview().offset(100)
            $0.height.equalTo(86)
        }

        self.view.addSubview(self.togetherFriendLabel)
        self.togetherFriendLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.top.equalTo(titleView.snp.bottom).offset(44)
        }

        self.view.addSubview(self.imgNiView)
        self.imgNiView.snp.makeConstraints {
            $0.centerY.equalTo(self.togetherFriendLabel.snp.centerY)
            $0.leading.equalTo(self.togetherFriendLabel.snp.trailing).offset(7)
            $0.width.height.equalTo(30)
        }

        self.view.addSubview(self.comeInLabel)
        self.comeInLabel.snp.makeConstraints {
            $0.leading.equalTo(self.imgNiView.snp.trailing)
            $0.centerY.equalTo(self.imgNiView.snp.centerY)
        }

        self.view.addSubview(self.copyButton)
        self.copyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.centerY.equalTo(self.togetherFriendLabel.snp.centerY)
        }

        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(65)
            $0.height.equalTo(60)
        }
    }

    override func configureUI() {
        super.configureUI()
        self.setupSettingButton()
    }
    
    // MARK: - API
    
    private func requestWaitRoomInfo() {
        Task {
            do {
                let data = try await self.detailWaitService.getWaitingRoomInfo(roomId: "\(roomIndex)")
                if let roomInfo = data {
                    guard let title = roomInfo.roomInformation?.title,
                          let state = roomInfo.roomInformation?.state,
                          let participants = roomInfo.participants,
                          let isAdmin = roomInfo.admin else { return }
                    self.room = roomInfo
                    self.userArr = participants.membersNickname
                    self.memberType = isAdmin ? .owner : .member
                    self.roomInfo = roomInfo.roomDTO
                    self.setStartButton()
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
                let data = try await self.detailWaitService.startManitto(roomId: "\(roomIndex)")
                if let manittee = data {
                    guard let nickname = manittee.nickname else { return }
                    self.presentSelectManittoViewController(nickname: nickname)
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
                let status = try await self.detailWaitService.deleteRoom(roomId: "\(roomIndex)")
                if status == 204 {
                    self.navigationController?.popViewController(animated: true)
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
                let status = try await self.detailWaitService.deleteLeaveRoom(roomId: "\(roomIndex)")
                if status == 204 {
                    self.navigationController?.popViewController(animated: true)
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
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func presentDetailEditViewController(startString: String, endString: String, isDateEdit: Bool) {
        guard let title = self.titleView.roomTitleLabel.text else { return }
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
        self.present(viewController, animated: true, completion: nil)
    }

    // MARK: - private func

    private func setupSettingButton() {
        let rightOffsetSettingButton = super.removeBarButtonItemOffset(with: settingButton,
                                                                       offsetX: -10)
        let settingButton = super.makeBarButtonItem(with: rightOffsetSettingButton)

        self.navigationItem.rightBarButtonItem = settingButton
    }

    private func setExitButtonMenu() -> UIMenu {
        let children: [UIAction] = memberType == .owner
        ? [UIAction(title: TextLiteral.modifiedRoomInfo, handler: { [weak self] _ in
            self?.presentEditRoomView()
        }),UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
               self?.makeRequestAlert(title: UserStatus.owner.alertText.title,
                                      message: UserStatus.owner.alertText.message,
                                      okTitle: UserStatus.owner.alertText.okTitle,
                                      okAction: { _ in
                   self?.requestDeleteRoom()
                   
               })
            
        })
        ]
        : [UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
            self?.makeRequestAlert(title: UserStatus.member.alertText.title,
                                   message: UserStatus.member.alertText.message,
                                   okTitle: UserStatus.member.alertText.okTitle,
                                   okAction: { _ in
                self?.requestDeleteLeaveRoom()
            })
        })]
        let menu = UIMenu(children: children)
        return menu
    }

    private func presentEditRoomView() {
        guard let roomInformation = self.room?.roomInformation else { return }
        if roomInformation.isAlreadyPastDate {
            self.editInfoFromDefaultDate(isDateEdit: false)
        } else {
            self.editInfoFromCurrentDate()
        }
    }
    
    private func editInfoFromDefaultDate(isDateEdit: Bool) {
        let fiveDaysInterval: TimeInterval = 86400 * 4
        let defaultStartDate = Date().dateToString
        let defaultEndDate = (Date() + fiveDaysInterval).dateToString
        self.presentDetailEditViewController(startString: defaultStartDate,
                                             endString: defaultEndDate,
                                             isDateEdit: isDateEdit)
    }
    
    private func editInfoFromCurrentDate() {
        guard let startDate = self.room?.roomInformation?.startDate,
              let endDate = self.room?.roomInformation?.endDate else { return }
        self.presentDetailEditViewController(startString: startDate,
                                             endString: endDate,
                                             isDateEdit: false)
    }

    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didTapEnterButton), name: .createRoomInvitedCode, object: nil)
    }

    private func isPastStartDate() {
        guard let isStart = self.room?.roomInformation?.isStart else { return }
        if !isStart {
            switch memberType {
            case .owner:
                let action: ((UIAlertAction) -> ()) = { [weak self] _ in
                    self?.editInfoFromDefaultDate(isDateEdit: true)
                }
                makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle,
                          message: TextLiteral.detailWaitViewControllerPastOwnerAlertMessage,
                          okAction: action)
            case .member:
                makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle,
                          message: TextLiteral.detailWaitViewControllerPastAlertMessage)
            }
        }
    }

    private func setStartButton() {
        if memberType == .owner {
            guard let canStart = self.room?.canStart else { return }
            self.detectStartableStatus?(canStart)
        } else {
            self.detectStartableStatus?(false)
        }
    }
    
    private func renderTableView() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
            self.view.addSubview(self.listTableView)
            var tableHeight = self.userArr.count * 44
            if tableHeight > 400 {
                tableHeight = 400
                self.listTableView.isScrollEnabled = true
            }
            self.listTableView.snp.makeConstraints {
                $0.top.equalTo(self.togetherFriendLabel.snp.bottom).offset(30)
                $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(tableHeight)
            }
        }
    }
    
    private func setupTitleViewGesture() {
        if self.memberType == .owner {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentEditViewController))
            self.titleView.addGestureRecognizer(tapGesture)
        }
    }
    
    private func presentSelectManittoViewController(nickname: String) {
        let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: SelectManittoViewController.className) as? SelectManittoViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.manitteeName = nickname
        viewController.roomId = self.roomInformation?.id?.description
        present(viewController, animated: true)
    }

    // MARK: - selector
    @objc private func didTapEnterButton() {
        guard let roomInfo = self.roomInfo,
              let code = self.room?.invitation?.code
        else { return }
        let viewController = InvitedCodeViewController(roomInfo: RoomDTO(title: roomInfo.title,
                                                             capacity: roomInfo.capacity,
                                                             startDate: roomInfo.startDate,
                                                             endDate: roomInfo.endDate),
                                                       code: code)
        viewController.roomInfo = roomInfo
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    @objc private func presentEditViewController() {
        guard let startDate = self.room?.roomInformation?.startDate,
              let endDate = self.room?.roomInformation?.endDate else { return }
        self.presentDetailEditViewController(startString: startDate,
                                             endString: endDate,
                                             isDateEdit: false)
    }
    
    @objc private func changeStartButton() {
        self.setStartButton()
    }
}

extension DetailWaitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension DetailWaitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.userArr[indexPath.row]
        cell.textLabel?.font = .font(.regular, ofSize: 17)
        cell.backgroundColor = .darkGrey003
        cell.selectionStyle = .none
        return cell
    }
}
