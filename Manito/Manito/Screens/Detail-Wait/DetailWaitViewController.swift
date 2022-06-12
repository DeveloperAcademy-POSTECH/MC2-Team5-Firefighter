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

    private enum StartStatus: String {
        case waiting = "대기중"
        case starting = "진행중"
        case complete = "완료"
    }

    // MARK: - property
    
    private lazy var settingButton: UIButton = {
        let button = SettingButton()
        let buttonAction = UIAction { _ in
            print("설정 버튼")
        }
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()

    private let roomTitle: UILabel = {
        let label = UILabel()
        label.text = "명예소방관"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 34)
        return label
    }()

    private let startStauts: UILabel = {
        let label = UILabel()
        label.text = StartStatus.waiting.rawValue
        label.backgroundColor = .badgeBeige
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .darkGrey004
        label.font = .font(.regular, ofSize: 13)
        label.textAlignment = .center
        return label
    }()

    private lazy var durationView: UIView = {
        let durationView = UIView()
        durationView.backgroundColor = .darkRed.withAlphaComponent(0.65)
        durationView.layer.cornerRadius = 8
        return durationView
    }()

    private let durationText: UILabel = {
        let durationText = UILabel()
        durationText.text = "진행 기간"
        durationText.textColor = .grey004
        durationText.font = .font(.regular, ofSize: 14)
        return durationText
    }()

    private let durationDateText: UILabel = {
        let dateText = UILabel()
        dateText.text = "22.06.06 ~ 22.06.10"
        dateText.textColor = .white
        dateText.font = .font(.regular, ofSize: 18)
        return dateText
    }()

    private let togetherFriendText: UILabel = {
        let label = UILabel()
        label.text = "함께하는 친구들"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 16)
        return label
    }()

    private lazy var comeInText: UILabel = {
        let label = UILabel()
        label.text = "\(userCount)/\(maxUser)"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 14)
        return label
    }()

    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("방 코드 복사", for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.addTarget(self, action: #selector(touchUpToShowToast), for: .touchUpInside)
        return button
    }()

    private let listTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = 10
        table.isScrollEnabled = false
        return table
    }()

    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .font(.regular, ofSize: 20)
        button.layer.cornerRadius = 30
        return button
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
        setupSettingButton()
    }

    override func render() {
        view.addSubview(roomTitle)
        roomTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }

        view.addSubview(startStauts)
        startStauts.snp.makeConstraints {
            $0.centerY.equalTo(roomTitle.snp.centerY)
            $0.leading.equalTo(roomTitle.snp.trailing).offset(10)
            $0.width.equalTo(66)
            $0.height.equalTo(23)
        }

        durationView.addSubview(durationText)
        durationView.addSubview(durationDateText)

        view.addSubview(durationView)
        durationView.snp.makeConstraints {
            $0.top.equalTo(roomTitle.snp.bottom).offset(30)
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }

        durationText.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        durationDateText.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        }

        view.addSubview(togetherFriendText)
        togetherFriendText.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(durationView.snp.bottom).offset(44)
        }

        view.addSubview(comeInText)
        comeInText.snp.makeConstraints {
            $0.leading.equalTo(togetherFriendText.snp.trailing).offset(10)
            $0.centerY.equalTo(togetherFriendText.snp.centerY)
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

        if canStart {
            startButton.setTitle("마니또 시작", for: .normal)
            startButton.setTitleColor(.white, for: .normal)
            startButton.backgroundColor = .mainRed
        } else {
            startButton.setTitle("시작을 기다리는 중...", for: .normal)
            startButton.setTitleColor(.white.withAlphaComponent(0.3), for: .normal)
            startButton.backgroundColor = .mainRed.withAlphaComponent(0.3)
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


    // MARK: - private func

    private func setupSettingButton() {
        let rightOffsetSettingButton = super.removeBarButtonItemOffset(with: settingButton, offsetX: -10)
        let settingButton = super.makeBarButtonItem(with: rightOffsetSettingButton)

        navigationItem.rightBarButtonItem = settingButton
    }

    // MARK: - selector

    @objc func touchUpToShowToast() {
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
