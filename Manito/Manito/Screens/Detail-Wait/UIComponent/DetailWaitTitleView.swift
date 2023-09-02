//
//  DetailWaitTitleView.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/12.
//

import UIKit

import SnapKit

final class DetailWaitTitleView: UIView {
    
    private enum StartStatus: String {
        case waiting
        case starting
        case complete
        
        var status: String{
            switch self {
            case .waiting:
                return TextLiteral.waiting
            case .starting:
                return TextLiteral.doing
            case .complete:
                return TextLiteral.cancel
            }
        }
    }

    // MARK: - ui component

    private(set) var roomTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 34)
        return label
    }()

    private let startStautsLabel: UILabel = {
        let label = UILabel()
        label.text = StartStatus.waiting.status
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
        durationText.text = TextLiteral.during
        durationText.textColor = .grey001
        durationText.font = .font(.regular, ofSize: 14)
        return durationText
    }()

    private let durationDateLabel: UILabel = {
        let dateText = UILabel()
        dateText.textColor = .white
        dateText.font = .font(.regular, ofSize: 18)
        return dateText
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    private func setupLayout() {
        self.addSubview(self.roomTitleLabel)
        self.roomTitleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }

        self.addSubview(self.startStautsLabel)
        self.startStautsLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.roomTitleLabel.snp.centerY)
            $0.leading.equalTo(self.roomTitleLabel.snp.trailing).offset(10)
            $0.width.equalTo(66)
            $0.height.equalTo(23)
        }

        self.addSubview(self.durationView)
        self.durationView.snp.makeConstraints {
            $0.top.equalTo(self.roomTitleLabel.snp.bottom).offset(30)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(36)
        }

        self.durationView.addSubview(self.durationLabel)
        self.durationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        self.durationView.addSubview(self.durationDateLabel)
        self.durationDateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setStartStatus(status: RoomStatus) {
        switch status {
        case .PRE:
            self.startStautsLabel.text = StartStatus.waiting.status
        case .PROCESSING:
            self.startStautsLabel.text = StartStatus.starting.status
        case .POST:
            self.startStautsLabel.text = StartStatus.complete.status
        }
    }
    
    func setupLabelData(title: String, dateRange: String) {
        self.roomTitleLabel.text = title
        self.durationDateLabel.text = dateRange
    }
}
