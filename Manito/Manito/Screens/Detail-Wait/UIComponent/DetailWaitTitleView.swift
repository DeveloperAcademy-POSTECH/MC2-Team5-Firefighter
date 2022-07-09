//
//  DetailWaitTitleView.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/12.
//

import UIKit

import SnapKit

class DetailWaitTitleView: UIView {
    var dateRangeText = "" {
        didSet {
            durationDateLabel.text = dateRangeText
        }
    }

    private enum StartStatus: String {
        case waiting = "대기중"
        case starting = "진행중"
        case complete = "완료"
    }

    // MARK: - property

    private let roomTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "명예소방관"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 34)
        return label
    }()

    private let startStautsLabel: UILabel = {
        let label = UILabel()
        label.text = StartStatus.waiting.rawValue
        label.backgroundColor = .badgeBeige
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textColor = .darkGrey001
        label.font = .font(.regular, ofSize: 13)
        label.textAlignment = .center
        return label
    }()

    private let durationView: UIView = {
        let durationView = UIView()
        durationView.backgroundColor = .red002
        durationView.layer.cornerRadius = 8
        return durationView
    }()

    private let durationLabel: UILabel = {
        let durationText = UILabel()
        durationText.text = "진행 기간"
        durationText.textColor = .grey001
        durationText.font = .font(.regular, ofSize: 14)
        return durationText
    }()

    private lazy var durationDateLabel: UILabel = {
        let dateText = UILabel()
        dateText.textColor = .white
        dateText.font = .font(.regular, ofSize: 18)
        return dateText
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    func render() {
        self.addSubview(roomTitleLabel)
        roomTitleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }

        self.addSubview(startStautsLabel)
        startStautsLabel.snp.makeConstraints {
            $0.centerY.equalTo(roomTitleLabel.snp.centerY)
            $0.leading.equalTo(roomTitleLabel.snp.trailing).offset(10)
            $0.width.equalTo(66)
            $0.height.equalTo(23)
        }

        self.addSubview(durationView)
        durationView.snp.makeConstraints {
            $0.top.equalTo(roomTitleLabel.snp.bottom).offset(30)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(36)
        }

        durationView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        durationView.addSubview(durationDateLabel)
        durationDateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        }
    }
}
