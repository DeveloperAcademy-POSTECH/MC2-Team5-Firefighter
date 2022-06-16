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
    private var isFirstTap = false
    private var selectStartDate = Date()
    private var memberCount = 7
    let testStartString = "2022-06-20"
    let testEndString = "2022-06-24"

    private enum CalendarMoveType {
        case previous
        case next

        var month: Int {
            switch self {
            case .previous:
                return -1
            case .next:
                return 1
            }
        }
    }

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
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        let action = UIAction { _ in
            self.changeMonth(with: CalendarMoveType.previous)
        }
        button.setTitle("<", for: .normal)
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        let action = UIAction { _ in
            self.changeMonth(with: CalendarMoveType.next)
        }
        button.setTitle(">", for: .normal)
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = .darkGrey001
        calendar.makeBorderLayer(color: .grey002)
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .grey005
        calendar.appearance.titleDefaultColor = .white.withAlphaComponent(0.8)
        // FIXME: weekdayTextColor와 색상이 같아서 수정이 필요해보임
        calendar.appearance.titlePlaceholderColor = .grey005
        calendar.appearance.headerTitleFont = .font(.regular, ofSize: 20)
        calendar.appearance.weekdayFont = .font(.regular, ofSize: 14)
        calendar.appearance.titleFont = .font(.regular, ofSize: 20)
        calendar.allowsMultipleSelection = true
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleWeekendColor = .mainRed.withAlphaComponent(0.8)
        return calendar
    }()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
    }

    override func configUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .darkGrey002
        setupDateRange()
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

        view.addSubview(previousButton)
        previousButton.snp.makeConstraints {
            $0.top.equalTo(startSettingLabel.snp.bottom).offset(38)
            $0.leading.equalToSuperview().inset(100)
        }

        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.top.equalTo(startSettingLabel.snp.bottom).offset(38)
            $0.trailing.equalToSuperview().inset(100)
        }

        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(25)
        }

        view.addSubview(setMemberLabel)
        setMemberLabel.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(60)
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
            $0.top.equalTo(setMemberLabel.snp.bottom).offset(40)
            $0.leading.equalTo(minMemberLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(maxMemberLabel.snp.leading).offset(-5)
            $0.height.equalTo(45)
            $0.centerY.equalTo(minMemberLabel.snp.centerY)
            $0.centerY.equalTo(maxMemberLabel.snp.centerY)
        }

        view.addSubview(memberCountLabel)
        memberCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(setMemberLabel.snp.centerY)
        }
    }

    // MARK: - func

    private func setupDelegation() {
        calendar.delegate = self
        calendar.dataSource = self
    }

    private func changeMonth(with type: CalendarMoveType) {
        let todayCalendar = Calendar.current
        var currentPage = calendar.currentPage
        var dateComponents = DateComponents()
        dateComponents.month = type.month
        currentPage = todayCalendar.date(byAdding: dateComponents, to: currentPage)!
        calendar.setCurrentPage(currentPage, animated: true)
    }

    private func setupDateRange() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let startDate = formatter.date(from: testStartString) else { return }
        guard let endDate = formatter.date(from: testEndString) else { return }
        setupCalendarRange(startDate: startDate, endDate: endDate)
    }

    private func setupCalendarRange(startDate: Date, endDate: Date) {
        calendar.select(startDate)
        calendar.select(endDate)
        setDateRange()
    }

    // MARK: - selector

    @objc
    private func changeMemberCount(sender: UISlider) {
        memberCountLabel.text = String(Int(sender.value)) + "인"
        memberCountLabel.font = .font(.regular, ofSize: 24)
        memberCountLabel.textColor = .white
    }
}

extension DetailModalController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if !isFirstTap {
            isFirstTap = true
        }
        let isClickedStartDate = calendar.selectedDates.count == 1
        let isSelectedDateRange = calendar.selectedDates.count == 2
        let isReclickedStartDate = calendar.selectedDates.count > 2

        if isClickedStartDate {
            selectStartDate = date
            calendar.reloadData()
        } else if isSelectedDateRange {
            if countDateRange() > 7 {
                calendar.deselect(date)
                makeAlert(title: "인원 수 제한", message: "최대 7일까지 선택가능해요 !")
            } else {
                setDateRange()
                calendar.reloadData()
            }
        } else if isReclickedStartDate {
            (calendar.selectedDates).forEach {
                calendar.deselect($0)
            }
            selectStartDate = date
            calendar.select(selectStartDate)
            calendar.reloadData()
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        for _ in 0 ..< calendar.selectedDates.count {
            calendar.deselect(calendar.selectedDates[0])
        }
        selectStartDate = date
        calendar.select(date)
        calendar.reloadData()
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date < Date() - 86400 {
            makeAlert(title: "과거로 가시게요..?", message: "오늘보다 이전 날짜는 \n 선택하실 수 없어요 !")
            return false
        } else {
            return true
        }
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let isBeforeToday = date < Date() - 86400
        let isAWeekBeforeAfter = date < selectStartDate + 604800 && date > selectStartDate - 604800
        let isDoneSelectedDate = calendar.selectedDates.count > 2
        if isBeforeToday {
            return .grey005.withAlphaComponent(0.4)
        } else if !isFirstTap {
            return .white
        } else if isAWeekBeforeAfter {
            return .white
        } else if isDoneSelectedDate {
            return .white
        } else {
            return .grey005.withAlphaComponent(0.6)
        }
    }

    // MARK: - func

    func setDateRange() {
        guard countDateRange() <= 7 else { return }

        let isFirstClickPastDate = calendar.selectedDates[0] < calendar.selectedDates[1]
        if isFirstClickPastDate {
            setSelecteDate(startIndex: 0, endIndex: 1)
        } else {
            setSelecteDate(startIndex: 1, endIndex: 0)
        }
    }

    func setSelecteDate(startIndex: Int, endIndex: Int) {
        var startDate = calendar.selectedDates[startIndex]
        while startDate < calendar.selectedDates[endIndex] {
            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            calendar.select(startDate)
        }
    }

    func countDateRange() -> Int {
        let isFirstClickPastDate = calendar.selectedDates[0] < calendar.selectedDates[1]
        let selectdDate = isFirstClickPastDate ? calendar.selectedDates[1].timeIntervalSince(calendar.selectedDates[0]) : calendar.selectedDates[0].timeIntervalSince(calendar.selectedDates[1])
        let dateRangeCount = selectdDate / 86400

        return Int(dateRangeCount) + 1
    }
}
extension DetailModalController: FSCalendarDataSource { }

extension DetailModalController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .darkRed
    }
}
