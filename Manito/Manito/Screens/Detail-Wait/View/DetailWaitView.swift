//
//  DetailWaitView.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/04/14.
//

import Combine
import UIKit

import SnapKit

final class DetailWaitView: UIView, BaseViewType {
    private enum UserStatus {
        case admin
        case member
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
    
    lazy var copyButtonPublisher: AnyPublisher<Void, Never> = self.copyButton.tapPublisher
    lazy var startButtonPublisher: AnyPublisher<Void, Never> = self.startButton.tapPublisher
    let editMenuButtonSubject = PassthroughSubject<Void, Never>()
    let deleteMenuButtonSubject = PassthroughSubject<Void, Never>()
    let leaveMenuButtonSubject = PassthroughSubject<Void, Never>()
    
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
    private let characterImageView: UIImageView = {
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
    
    private var userArray: [UserInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
                self.updateTableViewHeight()
            }
        }
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
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
        
        self.addSubview(self.characterImageView)
        self.characterImageView.snp.makeConstraints {
            $0.centerY.equalTo(self.togetherFriendLabel.snp.centerY)
            $0.leading.equalTo(self.togetherFriendLabel.snp.trailing).offset(7)
            $0.width.height.equalTo(30)
        }
        
        self.addSubview(self.userCountLabel)
        self.userCountLabel.snp.makeConstraints {
            $0.leading.equalTo(self.characterImageView.snp.trailing)
            $0.centerY.equalTo(self.characterImageView.snp.centerY)
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

    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    // MARK: - func
    
    private func setupTitleViewData(title: String, status: RoomStatus, dateRange: String) {
        self.titleView.setStartStatus(status: status)
        self.titleView.setupLabelData(title: title, dateRange: dateRange)
    }

    private func setupRelatedViews(of userStatus: Bool, _ isStart: Bool) {
        self.showStartButtonForAdmin(userStatus)
        self.setExitButtonMenu(userStatus)
        self.setupTitleViewGesture(userStatus)
    }

    private func configureUserCountLabel(userCount: String) {
        self.userCountLabel.text = userCount
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
        let type: ButtonText = canStart ? .start : .waiting
        self.startButton.title = type.status
        self.startButton.isDisabled = !canStart
    }
    
    private func setExitButtonMenu(_ isAdmin: Bool) {
        let type: UserStatus = isAdmin ? .admin : .member
        var children: [UIAction]
        switch type {
        case .admin:
            children = [UIAction(title: TextLiteral.modifiedRoomInfo, handler: { [weak self] _ in
                self?.editMenuButtonSubject.send(())
            }),UIAction(title: TextLiteral.detailWaitViewControllerDeleteRoom, handler: { [weak self] _ in
                self?.deleteMenuButtonSubject.send(())
            })
            ]
        case .member:
            children = [UIAction(title: TextLiteral.detailWaitViewControllerLeaveRoom, handler: { [weak self] _ in
                self?.leaveMenuButtonSubject.send(())
            })]
        }
        let menu = UIMenu(children: children)
        self.moreButton.menu = menu
    }
    
    private func setupTitleViewGesture(_ isAdmin: Bool) {
        if isAdmin {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentEditViewController))
            self.titleView.addGestureRecognizer(tapGesture)
        }
    }
    
    func configureNavigationItem(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let moreButton = UIBarButtonItem(customView: self.moreButton)
        
        navigationItem?.rightBarButtonItem = moreButton
    }
    
    func updateDetailWaitView(room: RoomInfo) {
        self.userArray = room.participants.members

        self.setupTitleViewData(title: room.roomInformation.title,
                                status: room.roomInformation.state,
                                dateRange: room.roomInformation.dateRangeText)
        self.setupRelatedViews(of: room.admin, room.roomInformation.isStart)

        self.configureStartButton(room.canStart)
        self.configureUserCountLabel(userCount: room.userCount)
    }
    
    // MARK: - selector
    
    @objc
    private func presentEditViewController() {
        self.editMenuButtonSubject.send(())
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
