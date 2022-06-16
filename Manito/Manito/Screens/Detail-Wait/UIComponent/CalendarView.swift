//
//  CalendarView.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/16.
//

import UIKit

import FSCalendar
import SnapKit

class CalendarView: UIView {
    private var selectStartDate = Date()

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

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        setupDelegation()
        setupDateRange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render() {
        self.addSubview(calendar)
        calendar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        self.addSubview(previousButton)
        previousButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(88)
        }

        self.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(90)
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
}

extension CalendarView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let isClickedStartDate = calendar.selectedDates.count == 1
        let isSelectedDateRange = calendar.selectedDates.count == 2
        let isReclickedStartDate = calendar.selectedDates.count > 2
        if isClickedStartDate {
            selectStartDate = date
            calendar.reloadData()
        } else if isSelectedDateRange {
            if countDateRange() > 7 {
                calendar.deselect(date)
                viewController?.makeAlert(title: "인원 수 제한", message: "최대 7일까지 선택가능해요 !")
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
            viewController?.makeAlert(title: "과거로 가시게요..?", message: "오늘보다 이전 날짜는 \n 선택하실 수 없어요 !")
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
extension CalendarView: FSCalendarDataSource { }

extension CalendarView: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .darkRed
    }
}
