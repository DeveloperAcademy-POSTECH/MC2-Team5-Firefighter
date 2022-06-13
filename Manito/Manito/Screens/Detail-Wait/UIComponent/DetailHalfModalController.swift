//
//  DetailHalfModalController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/13.
//

import UIKit

import FSCalendar
import SnapKit

class DetailHalfModalController: UIViewController {

    var memberCount = 7

    // MARK: - property

    private lazy var cancleButton: UIButton = {
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

    private lazy var changeText: UIButton = {
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

    private let titleText: UILabel = {
        let label = UILabel()
        label.text = "방 정보 수정"
        label.font = .font(.regular, ofSize: 16)
        return label
    }()

    private let startSettingText: UILabel = {
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
        calendar.layer.cornerRadius = 13 // 듀나의 코드가 pull이 안되서 좀따 수정하겠슴다
        calendar.layer.borderWidth = 1
        calendar.layer.borderColor = UIColor.white.cgColor
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = .white
        calendar.scrollDirection = .vertical
        calendar.appearance.headerTitleAlignment = .center // "2022년 6월" 가운데 정렬
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .grey006 // 월화수목금토일 글자색
        calendar.appearance.titleWeekendColor = .mainRed.withAlphaComponent(0.8) // 토일 숫자 색
        calendar.appearance.titleDefaultColor = .white.withAlphaComponent(0.8) // 월화수목금 숫자 색 (너무 쨍해서 0.8로 줬어요)
        // FIXME: weekdayTextColor와 색상이 같아서 수정이 필요해보임
        calendar.appearance.titlePlaceholderColor = .grey006
        calendar.appearance.headerTitleFont = .font(.regular, ofSize: 20)
        calendar.appearance.weekdayFont = .font(.regular, ofSize: 14)
        calendar.appearance.titleFont = .font(.regular, ofSize: 20)
        calendar.allowsMultipleSelection = true // 다중 선택 가능
        return calendar
    }()

    private let setMemberText: UILabel = {
        let label = UILabel()
        label.text = "인원 설정"
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .white
        return label
    }()

    private let minMemberText: UILabel = {
        let label = UILabel()
        label.text = "5인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()

    private let maxMemberText: UILabel = {
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
        slider.maximumTrackTintColor = .grey007
        slider.minimumTrackTintColor = .darkRed
        slider.value = Float(memberCount)
        return slider
    }()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
        setupDelegation()
        self.navigationController?.isNavigationBarHidden = true
    }

    private func configUI() {
        view.backgroundColor = .darkGrey002
    }

    private func render() {
        view.addSubview(cancleButton)
        cancleButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(29)
        }

        view.addSubview(changeText)
        changeText.snp.makeConstraints {
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

        view.addSubview(titleText)
        titleText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cancleButton.snp.centerY)
        }

        view.addSubview(startSettingText)
        startSettingText.snp.makeConstraints {
            $0.top.equalTo(cancleButton.snp.bottom).offset(51)
            $0.leading.equalToSuperview().inset(16)
        }

        view.addSubview(calendar)
        calendar.snp.makeConstraints {
            $0.top.equalTo(startSettingText.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(400)
            $0.width.equalTo(360)
        }

        view.addSubview(setMemberText)
        setMemberText.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(45)
            $0.leading.equalToSuperview().inset(16)
        }

        view.addSubview(minMemberText)
        minMemberText.snp.makeConstraints {
            $0.top.equalTo(setMemberText.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }

        view.addSubview(maxMemberText)
        maxMemberText.snp.makeConstraints {
            $0.top.equalTo(setMemberText.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(24)
        }

        view.addSubview(memberSlider)
        memberSlider.snp.makeConstraints {
            $0.top.equalTo(setMemberText.snp.bottom).offset(17)
            $0.leading.equalTo(minMemberText.snp.trailing).offset(5)
            $0.trailing.equalTo(maxMemberText.snp.leading).offset(-5)
            $0.height.equalTo(45)
            $0.centerY.equalTo(minMemberText.snp.centerY)
        }
    }

    // MARK: - func

    private func setupDelegation() {
        calendar.delegate = self
        calendar.dataSource = self
    }
}

extension DetailHalfModalController: FSCalendarDelegate { }
extension DetailHalfModalController: FSCalendarDataSource { }
