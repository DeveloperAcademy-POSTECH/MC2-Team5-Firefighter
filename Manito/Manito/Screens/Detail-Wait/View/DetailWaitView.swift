//
//  DetailWaitView.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/04/14.
//

import UIKit

import SnapKit

protocol DetailWaitViewDelegate: AnyObject {
    func startButtonDidTap()
    func presentRoomEditViewController(isOnlyDateEdit: Bool)
    func deleteButtonDidTap(title: String, message: String, okTitle: String)
    func leaveButtonDidTap(title: String, message: String, okTitle: String)
    func presentEditViewControllerAfterShowAlert()
    func showAlert(title: String, message: String)
    func codeCopyButtonDidTap(invitationCode: String)
}

final class DetailWaitView: UIView {
    private enum UserStatus: CaseIterable {
        case admin
        case member
        
        var alertText: (title: String,
                        message: String,
                        okTitle: String) {
            switch self {
            case .admin:
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
    private let niCharacterImageView: UIImageView = {
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
    
    // MARK: - property
    
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
            self.configureStartButton(self.canStart)
        }
    }
    
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
        
        self.addSubview(self.niCharacterImageView)
        self.niCharacterImageView.snp.makeConstraints {
            $0.centerY.equalTo(self.togetherFriendLabel.snp.centerY)
            $0.leading.equalTo(self.togetherFriendLabel.snp.trailing).offset(7)
            $0.width.height.equalTo(30)
        }
        
        self.addSubview(self.userCountLabel)
        self.userCountLabel.snp.makeConstraints {
            $0.leading.equalTo(self.niCharacterImageView.snp.trailing)
            $0.centerY.equalTo(self.niCharacterImageView.snp.centerY)
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
            self?.delegate?.codeCopyButtonDidTap(invitationCode: invitationCode)
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
    
    func bind(room: Room) {
        guard let title = room.roomInformation?.title,
              let state = room.roomInformation?.state,
              let dateRange = room.roomInformation?.dateRangeText,
              let users = room.participants?.members,
              let isAdmin = room.admin,
              let code = room.invitation?.code,
              let isStart = room.roomInformation?.isStart
        else { return }
        self.titleView.setRoomTitleLabelText(text: title)
        self.titleView.setStartState(state: state)
        self.userCountLabel.text = room.userCount
        self.titleView.setDurationDateLabel(text: dateRange)
        self.userArray = users
        self.showStartButtonForAdmin(isAdmin)
        self.canStart = room.canStart
        self.setExitButtonMenu(isAdmin)
        self.setupCopyButton(code)
        self.showAlertWhenPastDate(isAdmin, isStart: isStart)
        self.setupTitleViewGesture(isAdmin)
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
    
    private func showStartButtonForAdmin(_ isAdmin: Bool) {
        self.startButton.isHidden = !isAdmin
    }
    
    private func configureStartButton(_ canStart: Bool) {
        if canStart {
            self.startButton.title = ButtonText.start.status
            self.startButton.isDisabled = false
            let action = UIAction { [weak self] _ in
                self?.delegate?.startButtonDidTap()
            }
            self.startButton.addAction(action, for: .touchUpInside)
        } else {
            self.startButton.title = ButtonText.waiting.status
            self.startButton.isDisabled = true
        }
    }
    
    private func setExitButtonMenu(_ isAdmin: Bool) {
        var children: [UIAction]
        if isAdmin {
            children = [UIAction(title: TextLiteral.modifiedRoomInfo, handler: { [weak self] _ in
                self?.delegate?.presentRoomEditViewController(isOnlyDateEdit: false)
            }),UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
                self?.delegate?.deleteButtonDidTap(title: UserStatus.admin.alertText.title,
                                           message: UserStatus.admin.alertText.message,
                                           okTitle: UserStatus.admin.alertText.okTitle)
            })
            ]
        } else {
            children = [UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
                self?.delegate?.leaveButtonDidTap(title: UserStatus.member.alertText.title,
                                          message: UserStatus.member.alertText.message,
                                          okTitle: UserStatus.member.alertText.okTitle
                )
            })]
        }
        let menu = UIMenu(children: children)
        self.moreButton.menu = menu
    }
    
    private func showAlertWhenPastDate(_ isAdmin: Bool, isStart: Bool) {
        let type: UserStatus = isAdmin ? .admin : .member
        if !isStart {
            switch type {
            case .admin:
                self.delegate?.presentEditViewControllerAfterShowAlert()
            case .member:
                self.delegate?.showAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle,
                                         message: TextLiteral.detailWaitViewControllerPastAlertMessage)
            }
        }
    }
    
    private func setupTitleViewGesture(_ isAdmin: Bool) {
        if isAdmin {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentEditViewController))
            self.titleView.addGestureRecognizer(tapGesture)
        }
    }
    
    // MARK: - selector
    
    @objc
    private func presentEditViewController() {
        self.delegate?.presentRoomEditViewController(isOnlyDateEdit: false)
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
        var cellConfigure = cell.defaultContentConfiguration()
        cellConfigure.text =  self.userArray[indexPath.row].nickname
        cellConfigure.textProperties.font = .font(.regular, ofSize: 17)
        cell.contentConfiguration = cellConfigure
        cell.backgroundColor = .darkGrey003
        cell.selectionStyle = .none
        return cell
    }
}
