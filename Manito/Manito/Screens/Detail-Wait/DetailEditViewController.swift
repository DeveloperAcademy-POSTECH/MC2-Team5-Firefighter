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

    // MARK: - ui component

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
    private let topIndicatorView: UIView = {
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
        label.text = "\(Int(memberSlider.minimumValue))인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var maxMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(memberSlider.maximumValue))인"
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
    
    // MARK: - property
    
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    var didTappedChangeButton: (() -> ())?
    private let roomIndex: Int
    private let roomTitle: String
    enum EditMode {
        case date
        case information
    }
    var editMode: EditMode
    var currentUserCount: Int = 0
    var sliderValue: Int = 10
    var startDateText: String = "" {
        didSet {
            calendarView.startDateText = startDateText
            calendarView.setupDateRange()
        }
    }
    var endDateText: String = "" {
        didSet {
            calendarView.endDateText = endDateText
            calendarView.setupDateRange()
        }
    }

    // MARK: - life cycle
    
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
    
    override func configureUI() {
        super.configureUI()
        self.navigationController?.isNavigationBarHidden = true
        self.presentationController?.delegate = self
        isModalInPresentation = true
        setupChangedButton()
    }

    override func setupLayout() {
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

        view.addSubview(topIndicatorView)
        topIndicatorView.snp.makeConstraints {
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

        if editMode == .information {
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
    
    // MARK: - API
    
    private func putChangeRoomInfo(roomDto: RoomDTO) {
        Task {
            do {
                let status = try await detailWaitService.editRoomInfo(roomId: "\(roomIndex)", roomInfo: roomDto)
                if status == 204 {
                    ToastView.showToast(message: "방 정보 수정 완료", controller: self)
                    didTappedChangeButton?()
                    dismiss(animated: true)
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
        let dto = RoomDTO(title: roomTitle,
                          capacity: Int(memberSlider.value),
                          startDate: "20\(calendarView.getTempStartDate())",
                          endDate: "20\(calendarView.getTempEndDate())")
        switch editMode {
        case .date:
            putChangeRoomInfo(roomDto: dto)
        case .information:
            if currentUserCount <= sliderValue {
                putChangeRoomInfo(roomDto: dto)
            } else {
                makeAlert(title: TextLiteral.detailEditViewControllerChangeRoomInfoAlertTitle, message: TextLiteral.detailEditViewControllerChangeRoomInfoAlertMessage)
            }
        }
    }
    
    // MARK: - selector

    @objc private func changeMemberCount(sender: UISlider) {
        sliderValue = Int(sender.value)
        memberCountLabel.text = String(Int(sender.value)) + TextLiteral.per
        memberCountLabel.font = .font(.regular, ofSize: 24)
        memberCountLabel.textColor = .white
    }
}

extension DetailEditViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        presentationControllerDidAttemptToDismissAlert()
    }
}
