//
//  DetailHalfModalController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/13.
//

import UIKit

import FSCalendar
import SnapKit

final class DetailEditViewController: BaseViewController {
    
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
        label.text = "\(Int(self.memberSlider.minimumValue))인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var maxMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(self.memberSlider.maximumValue))인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var memberSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 4
        slider.maximumValue = 15
        slider.maximumTrackTintColor = .darkGrey003
        slider.minimumTrackTintColor = .red001
        slider.value = Float(self.sliderValue)
        slider.isContinuous = true
        slider.setThumbImage(ImageLiterals.imageSliderThumb, for: .normal)
        return slider
    }()
    private lazy var memberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.sliderValue)" + TextLiteral.per
        label.font = .font(.regular, ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK: - property
    
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    var didTappedChangeButton: (() -> ())?
    private let roomIndex: Int
    private let roomTitle: String
    var editMode: EditMode
    var currentUserCount: Int = 0
    var sliderValue: Int = 10
    var startDateText: String = "" {
        didSet {
            self.calendarView.startDateText = startDateText
            self.calendarView.setupDateRange()
        }
    }
    var endDateText: String = "" {
        didSet {
            self.calendarView.endDateText = endDateText
            self.calendarView.setupDateRange()
        }
    }
    
    // MARK: - init
    
    init(editMode: EditMode, roomIndex: Int, title: String) {
        self.editMode = editMode
        self.roomIndex = roomIndex
        self.roomTitle = title
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - override
    
    override func configureUI() {
        super.configureUI()
        self.navigationController?.isNavigationBarHidden = true
        self.presentationController?.delegate = self
        self.isModalInPresentation = true
        self.setupCalendarChangeButton()
        self.setupCancleButton()
        self.setupChangeButton()
        self.setupMemberSlider()
    }

    override func setupLayout() {
        self.view.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(29)
            $0.width.height.equalTo(44)
        }

        self.view.addSubview(self.changeButton)
        self.changeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(29)
            $0.width.height.equalTo(44)
        }

        self.view.addSubview(self.topIndicatorView)
        self.topIndicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(3)
        }

        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.cancelButton.snp.centerY)
        }

        self.view.addSubview(self.startSettingLabel)
        self.startSettingLabel.snp.makeConstraints {
            $0.top.equalTo(self.cancelButton.snp.bottom).offset(51)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }

        self.view.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints {
            $0.top.equalTo(self.startSettingLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(400)
        }

        self.view.addSubview(tipLabel)
        self.tipLabel.snp.makeConstraints {
            $0.top.equalTo(self.calendarView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(25)
        }

        if self.editMode == .information {
            self.view.addSubview(self.setMemberLabel)
            self.setMemberLabel.snp.makeConstraints {
                $0.top.equalTo(self.calendarView.snp.bottom).offset(60)
                $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
            }

            self.view.addSubview(self.minMemberLabel)
            self.minMemberLabel.snp.makeConstraints {
                $0.top.equalTo(self.setMemberLabel.snp.bottom).offset(30)
                $0.leading.equalToSuperview().inset(24)
            }

            self.view.addSubview(self.memberSlider)
            self.memberSlider.snp.makeConstraints {
                $0.leading.equalTo(self.minMemberLabel.snp.trailing).offset(5)
                $0.height.equalTo(45)
                $0.centerY.equalTo(self.minMemberLabel.snp.centerY)
            }

            self.view.addSubview(self.maxMemberLabel)
            self.maxMemberLabel.snp.makeConstraints {
                $0.top.equalTo(self.setMemberLabel.snp.bottom).offset(30)
                $0.leading.equalTo(self.memberSlider.snp.trailing).offset(5)
                $0.trailing.equalToSuperview().inset(24)
            }

            self.view.addSubview(self.memberCountLabel)
            self.memberCountLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(self.setMemberLabel.snp.centerY)
            }
        }
    }

    // MARK: - func
    
    private func setupCancleButton() {
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        self.cancelButton.addAction(action, for: .touchUpInside)
    }
    
    private func setupChangeButton() {
        let action = UIAction { [weak self] _ in
            self?.didTapChangeButton()
        }
        self.changeButton.addAction(action, for: .touchUpInside)
    }
    
    private func setupMemberSlider() {
        let valueChangeAction = UIAction { [weak self] action in
            guard let sender = action.sender as? UISlider else { return }
            self?.changeMemberCount(sender: sender)
        }
        self.memberSlider.addAction(valueChangeAction, for: .valueChanged)
    }

    private func presentationControllerDidAttemptToDismissAlert() {
        guard self.calendarView.isFirstTap else {
            self.dismiss(animated: true)
            return
        }
        self.showDiscardChangAlert()
    }

    private func showDiscardChangAlert() {
        let actionTitles = [TextLiteral.destructive, TextLiteral.cancel]
        let actionStyle: [UIAlertAction.Style] = [.destructive, .cancel]
        let actions: [((UIAlertAction) -> Void)?] = [{ [weak self] _ in
            self?.dismiss(animated: true)
        }, nil]
        makeActionSheet(actionTitles: actionTitles,
                        actionStyle: actionStyle,
                        actions: actions)
    }

    private func setupCalendarChangeButton() {
        self.calendarView.changeButtonState = { [weak self] value in
            self?.changeButton.isEnabled = value
            self?.changeButton.setTitleColor(.subBlue, for: .normal)
            self?.changeButton.setTitleColor(.grey002, for: .disabled)
        }
    }

    private func didTapChangeButton() {
        let dto = RoomDTO(title: self.roomTitle,
                          capacity: Int(self.memberSlider.value),
                          startDate: "20\(self.calendarView.getTempStartDate())",
                          endDate: "20\(self.calendarView.getTempEndDate())")
        switch self.editMode {
        case .date:
            self.putChangeRoomInfo(roomDto: dto)
        case .information:
            if self.currentUserCount <= self.sliderValue {
                self.putChangeRoomInfo(roomDto: dto)
            } else {
                self.makeAlert(title: TextLiteral.detailEditViewControllerChangeRoomInfoAlertTitle,
                          message: TextLiteral.detailEditViewControllerChangeRoomInfoAlertMessage)
            }
        }
    }
    
    // MARK: - selector

    @objc
    private func changeMemberCount(sender: UISlider) {
        self.sliderValue = Int(sender.value)
        self.memberCountLabel.text = String(Int(sender.value)) + TextLiteral.per
        self.memberCountLabel.font = .font(.regular, ofSize: 24)
        self.memberCountLabel.textColor = .white
    }
    
    // MARK: - network
    
    private func putChangeRoomInfo(roomDto: RoomDTO) {
        Task {
            do {
                let status = try await self.detailWaitService.editRoomInfo(roomId: "\(roomIndex)",
                                                                           roomInfo: roomDto)
                if status == 204 {
                    ToastView.showToast(message: "방 정보 수정 완료",
                                        controller: self)
                    self.didTappedChangeButton?()
                    self.dismiss(animated: true)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
}

extension DetailEditViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.presentationControllerDidAttemptToDismissAlert()
    }
}
