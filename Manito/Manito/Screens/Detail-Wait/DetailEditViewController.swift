//
//  DetailHalfModalController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/13.
//

import UIKit

import SnapKit
import FSCalendar

class DetailEditViewController: BaseViewController {
    private var memberCount = 7

    // MARK: - property

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private let topIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 1.5
        return view
    }()
    private lazy var changeButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonAction = UIAction { _ in
            self.dismiss(animated: true)
        }
        button.setTitle("변경", for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방 정보 수정"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let startSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "진행기간 설정"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let calendarView = CalendarView()
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 7일까지 설정할 수 있어요 !"
        label.textColor = .grey005
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private let setMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "인원 설정"
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .white
        return label
    }()
    private let minMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "5인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let maxMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "15인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var memberSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 5
        slider.maximumValue = 15
        slider.maximumTrackTintColor = .grey006
        slider.minimumTrackTintColor = .darkRed
        slider.value = Float(memberCount)
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(changeMemberCount(sender:)), for: .valueChanged)
        return slider
    }()
    private lazy var memberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(memberCount)인"
        label.font = .font(.regular, ofSize: 24)
        label.textColor = .white
        return label
    }()

    // MARK: - life cycle

    override func configUI() {
        super.configUI()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func render() {
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(29)
            $0.width.height.equalTo(44)
        }

        view.addSubview(changeButton)
        changeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(29)
            $0.width.height.equalTo(44)
        }

        view.addSubview(topIndicator)
        topIndicator.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(3)
        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cancelButton.snp.centerY)
        }

        view.addSubview(startSettingLabel)
        startSettingLabel.snp.makeConstraints {
            $0.top.equalTo(cancelButton.snp.bottom).offset(51)
            $0.leading.equalToSuperview().inset(16)
        }

        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(startSettingLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(400)
        }

        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(25)
        }

        view.addSubview(setMemberLabel)
        setMemberLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(16)
        }

        view.addSubview(minMemberLabel)
        minMemberLabel.snp.makeConstraints {
            $0.top.equalTo(setMemberLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }

        view.addSubview(memberSlider)
        memberSlider.snp.makeConstraints {
            $0.leading.equalTo(minMemberLabel.snp.trailing).offset(5)
            $0.height.equalTo(45)
            $0.centerY.equalTo(minMemberLabel.snp.centerY)
        }

        view.addSubview(maxMemberLabel)
        maxMemberLabel.snp.makeConstraints {
            $0.top.equalTo(setMemberLabel.snp.bottom).offset(30)
            $0.leading.equalTo(memberSlider.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(24)
        }

        view.addSubview(memberCountLabel)
        memberCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(setMemberLabel.snp.centerY)
        }
    }

    // MARK: - selector

    @objc
    private func changeMemberCount(sender: UISlider) {
        memberCountLabel.text = String(Int(sender.value)) + "인"
        memberCountLabel.font = .font(.regular, ofSize: 24)
        memberCountLabel.textColor = .white
    }
}
