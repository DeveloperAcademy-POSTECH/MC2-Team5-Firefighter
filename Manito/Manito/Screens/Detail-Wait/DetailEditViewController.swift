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

    enum EditMode {
        case dateEditMode
        case infoEditMode
    }
    var editMode: EditMode
    var currentUserCount = 0
    var sliderValue = 10
    var startDateText = "" {
        didSet {
            calendarView.startDateText = startDateText
            calendarView.setupDateRange()
        }
    }
    var endDateText = "" {
        didSet {
            calendarView.endDateText = endDateText
            calendarView.setupDateRange()
        }
    }

    // MARK: - property

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        button.setTitle(TextLiteral.cancel, for: .normal)
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
        let buttonAction = UIAction { [weak self] _ in
            self?.didTapChangeButton()
        }
        button.setTitle(TextLiteral.change, for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.modifiedRoomInfo
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let startSettingLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.detailEditViewControllerStartSetting
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var calendarView = CalendarView()
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.maxMessage
        label.textColor = .grey004
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private lazy var setMemberLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.detailEditViewControllerSetMember
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .white
        return label
    }()
    private lazy var minMemberLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.minMember
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var maxMemberLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.maxMember
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var memberSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 5
        slider.maximumValue = 15
        slider.maximumTrackTintColor = .darkGrey003
        slider.minimumTrackTintColor = .red001
        slider.value = Float(sliderValue)
        slider.isContinuous = true
        slider.setThumbImage(ImageLiterals.imageSliderThumb, for: .normal)
        slider.addTarget(self, action: #selector(changeMemberCount(sender:)), for: .valueChanged)
        return slider
    }()
    private lazy var memberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(sliderValue)" + TextLiteral.per
        label.font = .font(.regular, ofSize: 24)
        label.textColor = .white
        return label
    }()

    // MARK: - life cycle
    
    init(editMode: EditMode) {
        self.editMode = editMode
        super.init()
        patchRefreshToken()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configUI() {
        super.configUI()
        self.navigationController?.isNavigationBarHidden = true
        self.presentationController?.delegate = self
        isModalInPresentation = true
        setupChangedButton()
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
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }

        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(startSettingLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(400)
        }

        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(25)
        }

        if editMode == .infoEditMode {
            view.addSubview(setMemberLabel)
            setMemberLabel.snp.makeConstraints {
                $0.top.equalTo(calendarView.snp.bottom).offset(60)
                $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
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
    }

    // MARK: - selector

    @objc
    private func changeMemberCount(sender: UISlider) {
        sliderValue = Int(sender.value)
        memberCountLabel.text = String(Int(sender.value)) + TextLiteral.per
        memberCountLabel.font = .font(.regular, ofSize: 24)
        memberCountLabel.textColor = .white
    }

    // MARK: - func

    private func presentationControllerDidAttemptToDismissAlert() {
        guard calendarView.isFirstTap else {
            dismiss(animated: true)
            return
        }
        showDiscardChangAlert()
    }

    private func showDiscardChangAlert() {
        let actionTitles = [TextLiteral.destructive, TextLiteral.cancel]
        let actionStyle: [UIAlertAction.Style] = [.destructive, .cancel]
        let actions: [((UIAlertAction) -> Void)?] = [{ [weak self] _ in
            self?.dismiss(animated: true)
        }, nil]
        makeActionSheet(actionTitles: actionTitles, actionStyle: actionStyle, actions: actions)
    }

    private func setupChangedButton() {
        calendarView.changeButtonState = { [weak self] value in
            self?.changeButton.isEnabled = value
            self?.changeButton.setTitleColor(.subBlue, for: .normal)
            self?.changeButton.setTitleColor(.grey002, for: .disabled)
        }
    }

    private func didTapChangeButton() {
        switch editMode {
        case .dateEditMode:
            changeRoomDateRange()
        case .infoEditMode:
            changeRoomInfo()
        }
    }

    private func changeRoomDateRange() {
        NotificationCenter.default.post(name: .dateRangeNotification, object: nil, userInfo: ["startDate": calendarView.getTempStartDate(), "endDate": calendarView.getTempEndDate()])
        NotificationCenter.default.post(name: .changeStartButtonNotification, object: nil)
        NotificationCenter.default.post(name: .requestDateRangeNotification, object: nil, userInfo: ["startDate": "20\(calendarView.getTempStartDate())", "endDate": "20\(calendarView.getTempEndDate())"])
        dismiss(animated: true)
    }

    private func changeRoomInfo() {
        if currentUserCount <= sliderValue {
            NotificationCenter.default.post(name: .dateRangeNotification, object: nil, userInfo: ["startDate": calendarView.getTempStartDate(), "endDate": calendarView.getTempEndDate()])
            NotificationCenter.default.post(name: .changeStartButtonNotification, object: nil)
            NotificationCenter.default.post(name: .editMaxUserNotification, object: nil, userInfo: ["maxUser": memberSlider.value])
            NotificationCenter.default.post(name: .requestRoomInfoNotification, object: nil, userInfo: ["startDate": "20\(calendarView.getTempStartDate())", "endDate": "20\(calendarView.getTempEndDate())", "maxUser": Int(memberSlider.value)])
            dismiss(animated: true)
        } else {
            makeAlert(title: TextLiteral.detailEditViewControllerChangeRoomInfoAlertTitle, message: TextLiteral.detailEditViewControllerChangeRoomInfoAlertMessage)
        }
    }
}

extension DetailEditViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        presentationControllerDidAttemptToDismissAlert()
    }
}
