//
//  DetailEditView.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/04/20.
//

import UIKit

import SnapKit

protocol DetailEditDelegate: AnyObject {
    func cancelButtonDidTap()
    func changeButtonDidTap(capacity: Int, from startDate: String, to endDate: String)
}

final class DetailEditView: UIView, BaseViewType {
    
    enum EditMode {
        case date
        case information
    }
    
    // MARK: - ui component
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.cancel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        return button
    }()
    private let topIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 1.5
        return view
    }()
    private let changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.change, for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.modifiedRoomInfo
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let manittoPeriodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.detailEditViewControllerStartSetting
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    let calendarView: CalendarView = CalendarView()
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.maxMessage
        label.textColor = .grey004
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private lazy var numberOfParticipantsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.detailEditViewControllerSetMember
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .white
        return label
    }()
    private lazy var minimumNumberOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(self.participantsSlider.minimumValue))인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var maxNumberOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(self.participantsSlider.maximumValue))인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var participantsSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 4
        slider.maximumValue = 15
        slider.maximumTrackTintColor = .darkGrey003
        slider.minimumTrackTintColor = .red001
        slider.isContinuous = true
        slider.setThumbImage(UIImage.Image.sliderThumb, for: .normal)
        return slider
    }()
    private lazy var numberOfParticipantsLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK: - property
    
    private weak var delegate: DetailEditDelegate?
    private weak var calendarDelegate: CalendarDelegate?
    private let editMode: EditMode
    private var maximumMemberCount: Int? {
        willSet(count) {
            if let count {
                self.numberOfParticipantsLabel.text = count.description + TextLiteral.per
            }
        }
    }
    
    // MARK: - init
    
    init(editMode: EditMode) {
        self.editMode = editMode
        super.init(frame: .zero)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(29)
            $0.width.height.equalTo(44)
        }
        
        self.addSubview(self.changeButton)
        self.changeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(29)
            $0.width.height.equalTo(44)
        }
        
        self.addSubview(self.topIndicatorView)
        self.topIndicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(3)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.cancelButton.snp.centerY)
        }
        
        self.addSubview(self.manittoPeriodTitleLabel)
        self.manittoPeriodTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.cancelButton.snp.bottom).offset(51)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints {
            $0.top.equalTo(self.manittoPeriodTitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(400)
        }
        
        self.addSubview(self.helpLabel)
        self.helpLabel.snp.makeConstraints {
            $0.top.equalTo(self.calendarView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        if self.editMode == .information {        
            self.setupEditMembersLayout()
            self.setupMemberSlider()
        }
    }

    func configureUI() {
        self.backgroundColor = .backgroundGrey
        self.setupCancleButton()
        self.setupChangeButton()
    }

    // MARK: - func

    private func setupEditMembersLayout() {
        self.addSubview(self.numberOfParticipantsTitleLabel)
        self.numberOfParticipantsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.calendarView.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.minimumNumberOfParticipantsLabel)
        self.minimumNumberOfParticipantsLabel.snp.makeConstraints {
            $0.top.equalTo(self.numberOfParticipantsTitleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }
        
        self.addSubview(self.participantsSlider)
        self.participantsSlider.snp.makeConstraints {
            $0.leading.equalTo(self.minimumNumberOfParticipantsLabel.snp.trailing).offset(5)
            $0.height.equalTo(45)
            $0.centerY.equalTo(self.minimumNumberOfParticipantsLabel.snp.centerY)
        }
        
        self.addSubview(self.maxNumberOfParticipantsLabel)
        self.maxNumberOfParticipantsLabel.snp.makeConstraints {
            $0.top.equalTo(self.numberOfParticipantsTitleLabel.snp.bottom).offset(30)
            $0.leading.equalTo(self.participantsSlider.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        self.addSubview(self.numberOfParticipantsLabel)
        self.numberOfParticipantsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.numberOfParticipantsTitleLabel.snp.centerY)
        }
    }
    
    private func setupCancleButton() {
        let action = UIAction { [weak self] _ in
            self?.delegate?.cancelButtonDidTap()
        }
        self.cancelButton.addAction(action, for: .touchUpInside)
    }
    
    private func setupChangeButton() {
        let action = UIAction { [weak self] _ in
            guard let capacity = self?.participantsSlider.value,
                  let startDateString = self?.calendarView.getTempStartDate(),
                  let endDateString = self?.calendarView.getTempEndDate() else { return }
            self?.delegate?.changeButtonDidTap(capacity: Int(capacity),
                                                  from: startDateString,
                                                  to: endDateString)
        }
        self.changeButton.addAction(action, for: .touchUpInside)
    }
    
    func setupChangeButton(_ value: Bool) {
        self.changeButton.isEnabled = value
        self.changeButton.setTitleColor(.subBlue, for: .normal)
        self.changeButton.setTitleColor(.grey002, for: .disabled)
    }
    
    private func setupMemberSlider() {
        let valueChangeAction = UIAction { [weak self] action in
            guard let sender = action.sender as? UISlider else { return }
            self?.changeMemberSliderValue(sender: sender)
        }
        self.participantsSlider.addAction(valueChangeAction, for: .valueChanged)
    }
    
    private func changeMemberSliderValue(sender: UISlider) {
        self.maximumMemberCount = Int(sender.value)
    }
    
    func setupSliderValue(_ value: Int) {
        self.maximumMemberCount = value
        self.participantsSlider.value = Float(value)
    }
    
    func setupDateRange(from startDateString: String, to endDateString: String) {
        guard let startDate = startDateString.stringToDate else { return }
        if startDate.isPast {
            let fiveDaysInterval: TimeInterval = 86400 * 4
            self.calendarView.startDateText = Date().dateToString
            self.calendarView.endDateText = (Date() + fiveDaysInterval).dateToString
        } else {
            self.calendarView.startDateText = startDateString
            self.calendarView.endDateText = endDateString
        }
        self.calendarView.setupDateRange()
    }
    
    func configureDelegation(_ delegate: DetailEditDelegate) {
        self.delegate = delegate
    }
    
    func configureCalendarDelegate(_ delegate: CalendarDelegate) {
        self.calendarView.configureCalendarDelegate(delegate)
    }
}
