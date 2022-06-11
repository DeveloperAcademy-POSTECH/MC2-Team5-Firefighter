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

    private func attribute() {
        listTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private let roomTitle: UILabel = {
        let label = UILabel()
        label.text = "명예소방관"
        label.textColor = .white
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 34)
        return label
    }()

    private let startStauts: UILabel = {
        let label = UILabel()
        // MARK: enum으로 만드는게 좋아보임
        label.text = "대기중"
        label.backgroundColor = .waitBackgroundColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .waitTextColor
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 13)
        label.textAlignment = .center
        return label
    }()

    private lazy var durationView: UIView = {
        let durationView = UIView()
        durationView.backgroundColor = .durationBackgroundColor
        durationView.layer.cornerRadius = 8
        durationView.addSubview(durationText)
        durationView.addSubview(durationDateText)
        return durationView
    }()

    private let durationText: UILabel = {
        let durationText = UILabel()
        durationText.text = "진행 기간"
        durationText.textColor = .grey4
        durationText.font = UIFont(name: AppFontName.regular.rawValue, size: 14)
        return durationText
    }()

    private let durationDateText: UILabel = {
        let dateText = UILabel()
        dateText.text = "22.06.06 ~ 22.06.10"
        dateText.textColor = .white
        dateText.font = UIFont(name: AppFontName.regular.rawValue, size: 18)
        return dateText
    }()

    private let togetherFriendText: UILabel = {
        let label = UILabel()
        label.text = "함께하는 친구들"
        label.textColor = .white
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 16)
        return label
    }()

    private let comeInText: UILabel = {
        let label = UILabel()
        label.text = "1/15"
        label.textColor = .white
        label.font = UIFont(name: AppFontName.regular.rawValue, size: 14)
        return label
    }()

    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("방 코드 복사", for: .normal)
        button.titleLabel?.font = UIFont(name: AppFontName.regular.rawValue, size: 16)
        button.addTarget(self, action: #selector(copyInviteCode), for: .touchUpInside)
        return button
    }()

    private let listTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = 10
        table.isScrollEnabled = false
        return table
    }()

    @objc func copyInviteCode() {
        // TODO: 코드 복사 토스트형식 만들기
        print("코드 복사 완료 !")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor
        listTable.delegate = self
        listTable.dataSource = self
        attribute()
        render()
        // Do any additional setup after loading the view.
    }

    override func render() {
        view.addSubview(roomTitle)
        roomTitle.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }

        view.addSubview(startStauts)
        startStauts.snp.makeConstraints {
            $0.centerY.equalTo(roomTitle.snp.centerY)
            $0.left.equalTo(roomTitle.snp.right).offset(10)
            $0.width.equalTo(66)
            $0.height.equalTo(23)
        }

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
    }
}

extension DetailWaitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = userArr[indexPath.row]
        cell.textLabel?.font = UIFont(name: AppFontName.regular.rawValue, size: 17)
        cell.backgroundColor = .grey3
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
