//
//  DetailHalfModalController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/13.
//

import UIKit

import FSCalendar
import SnapKit

class DetailModalController: BaseViewController {

    var memberCount = 7

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

    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = .darkGrey001
        calendar.makeBorderLayer(color: .grey002)
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = .white
        calendar.scrollDirection = .vertical
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .grey005
        calendar.appearance.titleWeekendColor = .mainRed.withAlphaComponent(0.8)
        calendar.appearance.titleDefaultColor = .white.withAlphaComponent(0.8)
        // FIXME: weekdayTextColor와 색상이 같아서 수정이 필요해보임
        calendar.appearance.titlePlaceholderColor = .grey005
        calendar.appearance.headerTitleFont = .font(.regular, ofSize: 20)
        calendar.appearance.weekdayFont = .font(.regular, ofSize: 14)
        calendar.appearance.titleFont = .font(.regular, ofSize: 20)
        calendar.allowsMultipleSelection = true
        return calendar
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
        return slider
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
    }

    override func configUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .darkGrey002
    }

    override func render() {
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(29)
        }

        view.addSubview(changeButton)
        changeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(29)
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

        view.addSubview(calendar)
        calendar.snp.makeConstraints {
            $0.top.equalTo(startSettingLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(400)
            $0.width.equalTo(360)
        }

        view.addSubview(setMemberLabel)
        setMemberLabel.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(45)
            $0.leading.equalToSuperview().inset(16)
        }

        view.addSubview(minMemberLabel)
        minMemberLabel.snp.makeConstraints {
            $0.top.equalTo(setMemberLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }

        view.addSubview(maxMemberLabel)
        maxMemberLabel.snp.makeConstraints {
            $0.top.equalTo(setMemberLabel.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(24)
        }

        view.addSubview(memberSlider)
        memberSlider.snp.makeConstraints {
            $0.top.equalTo(setMemberLabel.snp.bottom).offset(17)
            $0.leading.equalTo(minMemberLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(maxMemberLabel.snp.leading).offset(-5)
            $0.height.equalTo(45)
            $0.centerY.equalTo(minMemberLabel.snp.centerY)
        }
    }

    // MARK: - func

    private func setupDelegation() {
        calendar.delegate = self
        calendar.dataSource = self
    }
}

extension DetailModalController: FSCalendarDelegate { }
extension DetailModalController: FSCalendarDataSource { }
