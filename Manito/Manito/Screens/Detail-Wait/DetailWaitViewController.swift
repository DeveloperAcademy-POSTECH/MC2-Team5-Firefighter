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
    var canStart = false
    var maxUser = 15
    lazy var userCount = userArr.count
    let isOwner = true

    private enum UserStatus: Int, CaseIterable {
        case owner = 0
        case member = 1

        var buttonTitle: String {
            switch self {
            case .owner:
                return "마니또 시작"
            case .member:
                return "시작을 기다리는 중..."
            }
        }

        var buttonDisabled: Bool {
            switch self {
            case .owner:
                return false
            case .member:
                return true
            }
        }

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
    private let titleView = DetailWaitTitleView()
    private let togetherFriendText: UILabel = {
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
    private lazy var comeInText: UILabel = {
        let label = UILabel()
        label.text = "\(userCount)/\(maxUser)"
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
        if canStart {
            button.title = ButtonText.start.rawValue
            button.isDisabled = false
        } else {
            button.title = ButtonText.waiting.rawValue
            button.isDisabled = true
        }
        return button
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
    }

    override func render() {
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(100)
            $0.height.equalTo(86)
        }

        view.addSubview(togetherFriendText)
        togetherFriendText.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(titleView.snp.bottom).offset(44)
        }
        
        view.addSubview(imgNiView)
        imgNiView.snp.makeConstraints {
            $0.centerY.equalTo(togetherFriendText.snp.centerY)
            $0.leading.equalTo(togetherFriendText.snp.trailing).offset(7)
            $0.width.height.equalTo(30)
        }

        view.addSubview(comeInText)
        comeInText.snp.makeConstraints {
            $0.leading.equalTo(imgNiView.snp.trailing)
            $0.centerY.equalTo(imgNiView.snp.centerY)
        }

        view.addSubview(copyButton)
        copyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(togetherFriendText.snp.centerY)
        }

        view.addSubview(listTable)
        var tableHeight = userArr.count * 44
        if tableHeight > 400 {
            tableHeight = 400
            listTable.isScrollEnabled = true
        }
        listTable.snp.makeConstraints {
            $0.top.equalTo(togetherFriendText.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(tableHeight)
        }

        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(65)
            $0.height.equalTo(60)
        }
    }

    override func configUI() {
        view.backgroundColor = .darkGrey002
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
        toastLabel.backgroundColor = .grey003
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

    private func presentModal() {
        let modalViewController = DetailModalController()

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
                    UIAction(title: "방 정보 수정", handler: { _ in
                        self.presentModal()
                    }),
                    UIAction(title: "방 삭제", handler: { _ in
                        self.makeRequestAlert(title: UserStatus.owner.alertText.title, message: UserStatus.owner.alertText.message, okTitle: UserStatus.owner.alertText.okTitle, okAction: nil)
                    })])
            return menu
        } else {
            let menu = UIMenu(options: [], children: [
                    UIAction(title: "방 나가기", handler: { _ in
                        self.makeRequestAlert(title: UserStatus.member.alertText.title, message: UserStatus.member.alertText.message, okTitle: UserStatus.member.alertText.okTitle, okAction: nil)
                    })
                ])
            return menu
        }
    }

    private func touchUpToShowToast() {
        UIPasteboard.general.string = "초대코드"
        self.showToast(message: "코드 복사 완료!")
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
        cell.backgroundColor = .darkGrey001
        cell.selectionStyle = .none
        return cell
    }
}
