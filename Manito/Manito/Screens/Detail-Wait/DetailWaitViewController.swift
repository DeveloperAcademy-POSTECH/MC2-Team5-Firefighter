//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class DetailWaitViewController: BaseViewController {
    let userArr = ["호야", "리비", "듀나", "코비", "디너", "케미"]
    var canStartClosure: ((Bool) -> ())?
    var maxUserCount = 15
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

//        var buttonTitle: String {
//            switch self {
//            case .owner:
//                return "마니또 시작"
//            case .member:
//                return "시작을 기다리는 중..."
//            }
//        }

//        var buttonDisabled: Bool {
//            switch self {
//            case .owner:
//                return false
//            case .member:
//                return true
//            }
//        }

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
                return "방을 삭제하실건가요?"
            case .exit:
                return "정말 나가실거예요?"
            }
        }

        var message: String {
            switch self {
            case .delete:
                return "방을 삭제하시면 다시 되돌릴 수 없습니다."
            case .exit:
                return "초대코드를 입력하면 \n 다시 들어올 수 있어요."
            }
        }

        var okTitle: String {
            switch self {
            case .delete:
                return "삭제"
            case .exit:
                return "나가기"
            }
        }
    }

    private enum ButtonText: String {
        case waiting = "시작을 기다리는 중..."
        case start = "마니또 시작"
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
        view.dateRangeText = "\(startDateText) ~ \(endDateText)"
        return view
    }()
    private let togetherFriendLabel: UILabel = {
        let label = UILabel()
        label.text = "함께하는 친구들"
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
        let buttonAction = UIAction { _ in
            self.touchUpToShowToast()
        }
        button.setTitle("방 코드 복사", for: .normal)
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
                button.title = ButtonText.start.rawValue
                button.isDisabled = false
                let action = UIAction { _ in
                    let storyboard = UIStoryboard(name: "Interaction", bundle: nil)
                    guard let viewController = storyboard.instantiateViewController(withIdentifier: SelectManittoViewController.className) as? SelectManittoViewController else { return }
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                }
                button.addAction(action, for: .touchUpInside)
            } else {
                button.title = ButtonText.waiting.rawValue
                button.isDisabled = true
            }
        }
        return button
    }()

    // MARK: - life cycle

    deinit {
        print("deInit")
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

    private func presentModal(from startString: String, to endString: String) {
        let modalViewController = DetailEditViewController()
        modalViewController.startDateText = startString
        modalViewController.endDateText = endString
        present(modalViewController, animated: true, completion: nil)
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
                    UIAction(title: "방 정보 수정", handler: { [weak self] _ in
                        guard let startDate = self?.startDateText else { return }
                        guard let endDate = self?.endDateText else { return }
                        self?.presentModal(from: startDate, to: endDate)
                    }),
                    UIAction(title: "방 삭제", handler: { [weak self] _ in
                        self?.makeRequestAlert(title: UserStatus.owner.alertText.title, message: UserStatus.owner.alertText.message, okTitle: UserStatus.owner.alertText.okTitle, okAction: nil)
                    })])
            return menu
        } else {
            let menu = UIMenu(options: [], children: [
                    UIAction(title: "방 나가기", handler: { [weak self] _ in
                        self?.makeRequestAlert(title: UserStatus.member.alertText.title, message: UserStatus.member.alertText.message, okTitle: UserStatus.member.alertText.okTitle, okAction: nil)
                    })
                ])
            return menu
        }
    }

    private func touchUpToShowToast() {
        UIPasteboard.general.string = "초대코드"
        self.showToast(message: "코드 복사 완료!")
    }

    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDateRange(_:)), name: .dateRangeNotification, object: nil)
    }

    private func isPastStartDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        guard let startDate = formatter.date(from: startDateText) else { return }
        let isPast = startDate.distance(to: Date()) > 0
        let isToday = startDate.distance(to: Date()) < 86400
        if !isPast && !isToday {
            if isOwner {
                let action: ((UIAlertAction) -> ()) = { [weak self] _ in
                    let fiveDaysInterval: TimeInterval = 86400 * 4
                    let startDate = formatter.string(from: Date())
                    let endDate = formatter.string(from: Date() + fiveDaysInterval)
                    self?.presentModal(from: startDate, to: endDate)
                }
                makeAlert(title: "날짜를 재설정 해주세요", message: "마니또 시작일이 지났습니다. \n 진행기간을 재설정 해주세요", okAction: action)
            } else {
                makeAlert(title: "시작일이 지났어요", message: "방장이 진행기간을 재설정 \n 할 때까지 기다려주세요")
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
        guard let noti = notification.userInfo else { return }

        guard let startDate = noti["startDate"] as? String else { return }
        guard let endDate = noti["endDate"] as? String else { return }

        self.startDateText = startDate
        self.endDateText = endDate
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
