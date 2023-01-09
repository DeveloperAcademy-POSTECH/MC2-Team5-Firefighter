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

    // MARK: - property

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
        render()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
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
    
    // MARK: - func
    
    func setStartState(state: String) {
        switch state {
        case "PRE":
            startStautsLabel.text = StartStatus.waiting.status
        case "PROCESSING":
            startStautsLabel.text = StartStatus.starting.status
        case "POST":
            startStautsLabel.text = StartStatus.complete.status
        default:
            startStautsLabel.text = StartStatus.waiting.status
        }
    }
    
    func setRoomTitleLabelText(text: String) {
        roomTitleLabel.text = text
    }
    
    func setDurationDateLabel(text: String) {
        durationDateLabel.text = text
    }
}
