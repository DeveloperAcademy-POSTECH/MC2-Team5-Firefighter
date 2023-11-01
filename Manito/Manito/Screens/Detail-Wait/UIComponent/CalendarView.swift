//
//  CalendarView.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/16.
//

import Combine
import UIKit

import FSCalendar
import SnapKit

protocol CalendarDelegate: AnyObject {
    func detectChangeButton(_ value: Bool)
}

final class CalendarView: UIView {
    
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

    // MARK: - ui component

    private let previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.Button.back, for: .normal)
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.Icon.right, for: .normal)
        return button
    }()
    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = .darkGrey003
        calendar.makeBorderLayer(color: .grey002)
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .white.withAlphaComponent(0.8)
        calendar.appearance.titleDefaultColor = .white.withAlphaComponent(0.8)
        calendar.appearance.titlePlaceholderColor = .grey004
        calendar.appearance.headerTitleFont = .font(.regular, ofSize: 20)
        calendar.appearance.weekdayFont = .font(.regular, ofSize: 14)
        calendar.appearance.titleFont = .font(.regular, ofSize: 20)
        calendar.allowsMultipleSelection = true
        calendar.appearance.todayColor = .clear
        return calendar
    }()
    
    // MARK: - property
    
    private var selectStartDate: Date = Date()
    private let oneDayInterval: TimeInterval = 86400
    private let sevenDaysInterval: TimeInterval = 604800
    var changeButtonState: ((Bool) -> ())?
    var startDateText: String = ""
    var endDateText: String = ""
    private var tempStartDateText: String = ""
    private var tempEndDateText: String = ""
    var isFirstTap: Bool = false
    private weak var delegate: CalendarDelegate?
    
    let startDateTapPublisher = PassthroughSubject<String, Never>()
    let endDateTapPublisher = PassthroughSubject<String, Never>()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupDelegation()
        self.setupDateRange()
        self.setupPreviousButton()
        self.setupNextButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    private func setupLayout() {
        self.addSubview(self.calendar)
        self.calendar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.addSubview(self.previousButton)
        self.previousButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(70)
        }

        self.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(72)
        }
    }
    
    private func setupPreviousButton() {
        let action = UIAction { [weak self] _ in
            self?.changeMonth(with: .previous)
        }
        self.previousButton.addAction(action, for: .touchUpInside)
    }
    private func setupNextButton() {
        let action = UIAction { [weak self] _ in
            self?.changeMonth(with: CalendarMoveType.next)
        }
        self.nextButton.addAction(action, for: .touchUpInside)
    }
    
    func configureCalendarDelegate(_ delegate: CalendarDelegate) {
        self.delegate = delegate
    }
    
    func setupButtonState() {
        let hasDate = self.tempStartDateText != "" && self.tempEndDateText != ""
        self.delegate?.detectChangeButton(hasDate)
        // FIXME: - delegate로 통일 후 삭제해야함
        self.changeButtonState?(hasDate)
    }

    private func setupDelegation() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
    }

    private func changeMonth(with type: CalendarMoveType) {
        let todayCalendar = Calendar.current
        let currentPage = self.calendar.currentPage
        var dateComponents = DateComponents()
        dateComponents.month = type.month
        guard let changedCurrentPage = todayCalendar.date(byAdding: dateComponents, to: currentPage) else { return }
        self.calendar.setCurrentPage(changedCurrentPage, animated: true)
    }

    func setupDateRange() {
        self.startDateTapPublisher.send("20\(self.startDateText)")
        self.endDateTapPublisher.send("20\(self.endDateText)")
        guard let startDate = self.startDateText.toDefaultDate else { return }
        guard let endDate = self.endDateText.toDefaultDate else { return }
        self.setupCalendarRange(startDate: startDate, endDate: endDate)
    }

    private func setupCalendarRange(startDate: Date, endDate: Date) {
        self.calendar.select(startDate)
        self.calendar.select(endDate)
        self.setDateRange()
    }

    func setDateRange() {
        guard self.countDateRange() <= 7 else { return }

        let isFirstClickPastDate = self.calendar.selectedDates[0] < self.calendar.selectedDates[1]
        if isFirstClickPastDate {
            self.setSelecteDate(startIndex: 0,
                                endIndex: 1)
        } else {
            self.setSelecteDate(startIndex: 1,
                                endIndex: 0)
        }
    }

    func setSelecteDate(startIndex: Int, endIndex: Int) {
        var startDate = self.calendar.selectedDates[startIndex]
        while startDate < self.calendar.selectedDates[endIndex] {
            guard let addDate = Calendar.current.date(byAdding: .day,
                                                      value: 1,
                                                      to: startDate) else { return }
            self.calendar.select(addDate)
            startDate += self.oneDayInterval
        }
        self.tempStartDateText = self.calendar.selectedDates[startIndex].toDefaultString
        self.tempEndDateText = self.calendar.selectedDates[endIndex].toDefaultString
    }

    func countDateRange() -> Int {
        let isFirstClickPastDate = self.calendar.selectedDates[0] < self.calendar.selectedDates[1]
        let selectdDate = isFirstClickPastDate
        ? self.calendar.selectedDates[1].timeIntervalSince(self.calendar.selectedDates[0])
        : self.calendar.selectedDates[0].timeIntervalSince(self.calendar.selectedDates[1])
        let dateRangeCount = selectdDate / 86400

        return Int(dateRangeCount) + 1
    }
    
    func getTempStartDate() -> String {
        return "20\(self.tempStartDateText)"
    }
    
    func getTempEndDate() -> String {
        return "20\(self.tempEndDateText)"
    }
}

extension CalendarView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.isFirstTap = true
        let isCreatedRoomOnlySelectedStartDate = calendar.selectedDates.count == 1
        let isSelectedDateRange = calendar.selectedDates.count == 2
        let isReclickedStartDate = calendar.selectedDates.count > 2
        if isCreatedRoomOnlySelectedStartDate {
            self.selectStartDate = date
            calendar.select(self.selectStartDate)
            calendar.reloadData()
        } else if isSelectedDateRange {
            if self.countDateRange() > 7 {
                DispatchQueue.main.async {                
                    calendar.deselect(date)
                }
                self.viewController?.makeAlert(title: TextLiteral.Common.Calendar.maxAlertTitle.localized(),
                                               message: TextLiteral.Common.Calendar.maxDateContent.localized())
            } else {
                self.tempEndDateText = date.toDefaultString
                self.setDateRange()
                calendar.reloadData()
            }
        } else if isReclickedStartDate {
            self.tempStartDateText = date.toDefaultString
            self.tempEndDateText = ""
            (calendar.selectedDates).forEach {
                calendar.deselect($0)
            }
            self.selectStartDate = date
            calendar.select(self.selectStartDate)
            calendar.reloadData()
        }
        
        self.startDateTapPublisher.send(self.getTempStartDate())
        self.endDateTapPublisher.send(self.getTempEndDate())
        self.setupButtonState()
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.tempEndDateText = ""
        self.isFirstTap = true
        (calendar.selectedDates).forEach {
            calendar.deselect($0)
        }
        self.selectStartDate = date
        calendar.select(date)
        calendar.reloadData()
        self.setupButtonState()
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date < Date() - self.oneDayInterval {
            self.viewController?.makeAlert(title: TextLiteral.Common.Calendar.pastAlertTitle.localized(),
                                           message: TextLiteral.Common.Calendar.pastAlertMessage.localized())
            return false
        } else {
            return true
        }
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let isBeforeToday = date < Date() - self.oneDayInterval
        let isAWeekBeforeAfter = date < self.selectStartDate + self.sevenDaysInterval && date > self.selectStartDate - self.sevenDaysInterval
        let isDoneSelectedDate = calendar.selectedDates.count > 2
        if isBeforeToday {
            return .grey004.withAlphaComponent(0.4)
        } else if !isFirstTap || (isAWeekBeforeAfter || isDoneSelectedDate) {
            return .white
        } else {
            return .grey004.withAlphaComponent(0.4)
        }
    }
}
extension CalendarView: FSCalendarDataSource { }

extension CalendarView: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .red001
    }
}
