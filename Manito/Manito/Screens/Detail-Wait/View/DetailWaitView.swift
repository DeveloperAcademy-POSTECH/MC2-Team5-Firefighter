//
//  DetailWaitView.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/04/14.
//

import UIKit

import SnapKit

protocol DetailWaitViewDelegate: AnyObject {
    // 마니또 시작
    func startManitto()
    // 방 정보 수정 뷰로 이동
    func presentRoomEditViewController(room: Room, _ isOnlyDateEdit: Bool)
    // 방 삭제
    func deleteRoom(title: String, message: String, okTitle: String)
    // 방 나가기
    func leaveRoom()
    // 시작 날짜 지남 alert 표시
    func presentEditViewControllerAfterShowAlert(room: Room)
    func showAlert(title: String, message: String)
}

final class DetailWaitView: UIView {
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
    
    private let moreButton: UIButton = {
        let button = MoreButton()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private let titleView: DetailWaitTitleView = DetailWaitTitleView()
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
    private let userCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.copyCode, for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        return button
    }()
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private let startButton: MainButton = MainButton()
    
    private var userArray: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
                self.updateTableViewHeight()
            }
        }
    }
    private var canStart: Bool = false {
        didSet {
            self.setStartButton(self.canStart)
        }
    }
    
    private var roomInformation: Room?
    private weak var delegate: DetailWaitViewDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.titleView)
        self.titleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.top.equalToSuperview().offset(100)
            $0.height.equalTo(86)
        }

        self.addSubview(self.togetherFriendLabel)
        self.togetherFriendLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.top.equalTo(titleView.snp.bottom).offset(44)
        }

        self.addSubview(self.imgNiView)
        self.imgNiView.snp.makeConstraints {
            $0.centerY.equalTo(self.togetherFriendLabel.snp.centerY)
            $0.leading.equalTo(self.togetherFriendLabel.snp.trailing).offset(7)
            $0.width.height.equalTo(30)
        }

        self.addSubview(self.userCountLabel)
        self.userCountLabel.snp.makeConstraints {
            $0.leading.equalTo(self.imgNiView.snp.trailing)
            $0.centerY.equalTo(self.imgNiView.snp.centerY)
        }

        self.addSubview(self.copyButton)
        self.copyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.centerY.equalTo(self.togetherFriendLabel.snp.centerY)
        }
        
        self.addSubview(self.listTableView)
        self.listTableView.snp.makeConstraints {
            $0.top.equalTo(self.togetherFriendLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }

        self.addSubview(self.startButton)
        self.startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.bottom.equalToSuperview().inset(65)
            $0.height.equalTo(60)
        }
    }
    
    private func setupCopyButton(_ invitationCode: String) {
        let action = UIAction { [weak self] _ in
            ToastView.showToast(code: invitationCode,
                                message: TextLiteral.detailWaitViewControllerCopyCode,
                                view: self ?? UIView())
        }
        self.copyButton.addAction(action, for: .touchUpInside)
    }
    
    func configureDelegation(_ delegate: DetailWaitViewDelegate) {
        self.delegate = delegate
    }
    
    func configureNavigationItem(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let moreButton = UIBarButtonItem(customView: self.moreButton)
        
        navigationItem?.rightBarButtonItem = moreButton
    }
    
    func configureLayout(room: Room) {
        self.roomInformation = room
        guard let title = room.roomInformation?.title,
              let state = room.roomInformation?.state,
              let dateRange = room.roomInformation?.dateRange,
              let users = room.participants?.members,
              let isOwner = room.admin,
              let code = room.invitation?.code,
              let isStart = room.roomInformation?.isStart
        else { return }
        self.titleView.setRoomTitleLabelText(text: title)
        self.titleView.setStartState(state: state)
        self.userCountLabel.text = room.userCount
        self.titleView.setDurationDateLabel(text: dateRange)
        self.userArray = users
        self.showStartButtonForAdmin(isOwner)
        self.canStart = room.canStart
        self.setExitButtonMenu(isOwner)
        self.setupCopyButton(code)
        self.showAlertWhenPastDate(isOwner, isStart: isStart)
    }
    
    private func updateTableViewHeight() {
        var tableHeight = self.userArray.count * 44
        if tableHeight > 400 {
            tableHeight = 400
            self.listTableView.isScrollEnabled = true
        }
        self.listTableView.snp.updateConstraints {
            $0.height.equalTo(tableHeight)
        }
    }
    
    private func showStartButtonForAdmin(_ isOwner: Bool) {
        self.startButton.isHidden = !isOwner
    }
    
    // FIXME: - configureStartButton이 더 났나?
    private func setStartButton(_ canStart: Bool) {
        if canStart {
            self.startButton.title = ButtonText.start.status
            self.startButton.isDisabled = false
            let action = UIAction { [weak self] _ in
                self?.delegate?.startManitto()
//                self?.requestStartManitto()
            }
            self.startButton.addAction(action, for: .touchUpInside)
        } else {
            self.startButton.title = ButtonText.waiting.status
            self.startButton.isDisabled = true
        }
    }
    
    private func setExitButtonMenu(_ isOwner: Bool) {
        var children: [UIAction]
        if isOwner {
            children = [UIAction(title: TextLiteral.modifiedRoomInfo, handler: { [weak self] _ in
                guard let roomInformation = self?.roomInformation else { return }
                self?.delegate?.presentRoomEditViewController(room: roomInformation, false)
            }),UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
                self?.delegate?.deleteRoom(title: UserStatus.owner.alertText.title,
                                           message: UserStatus.owner.alertText.message,
                                           okTitle: UserStatus.owner.alertText.okTitle)
            })
            ]
        } else {
            children = [UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
//                viewController.makeRequestAlert(title: UserStatus.member.alertText.title,
//                                       message: UserStatus.member.alertText.message,
//                                       okTitle: UserStatus.member.alertText.okTitle,
//                                       okAction: { _ in
                self?.delegate?.leaveRoom()
    //                self?.requestDeleteLeaveRoom()
//                })
            })]
        }
        let menu = UIMenu(children: children)
        self.moreButton.menu = menu
    }
    
    private func showAlertWhenPastDate(_ isAdmin: Bool, isStart: Bool) {
        let type: UserStatus = isAdmin ? .owner : .member
        if !isStart {
            switch type {
            case .owner:
                guard let roomInformation = self.roomInformation else { return }
                self.delegate?.presentEditViewControllerAfterShowAlert(room: roomInformation)
            case .member:
                self.delegate?.showAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle,
                                         message: TextLiteral.detailWaitViewControllerPastAlertMessage)
            }
        }
    }
}

extension DetailWaitView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension DetailWaitView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.userArray[indexPath.row].nickname
        cell.textLabel?.font = .font(.regular, ofSize: 17)
        cell.backgroundColor = .darkGrey003
        cell.selectionStyle = .none
        return cell
    }
}
