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
    
    private lazy var detailEditView = DetailEditView(maximumMemberCount: self.sliderValue)

//    private let cancelButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle(TextLiteral.cancel, for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = .font(.regular, ofSize: 16)
//        return button
//    }()
//    private let topIndicatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white.withAlphaComponent(0.8)
//        view.layer.cornerRadius = 1.5
//        return view
//    }()
//    private let changeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle(TextLiteral.change, for: .normal)
//        button.setTitleColor(.subBlue, for: .normal)
//        button.titleLabel?.font = .font(.regular, ofSize: 16)
//        return button
//    }()
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = TextLiteral.modifiedRoomInfo
//        label.font = .font(.regular, ofSize: 16)
//        return label
//    }()
//    private let startSettingLabel: UILabel = {
//        let label = UILabel()
//        label.text = TextLiteral.detailEditViewControllerStartSetting
//        label.font = .font(.regular, ofSize: 16)
//        label.textColor = .white
//        return label
//    }()
//    private let calendarView: CalendarView = CalendarView()
//    private let tipLabel: UILabel = {
//        let label = UILabel()
//        label.text = TextLiteral.maxMessage
//        label.textColor = .grey004
//        label.font = .font(.regular, ofSize: 14)
//        return label
//    }()
//    private let setMemberLabel: UILabel = {
//        let label = UILabel()
//        label.text = TextLiteral.detailEditViewControllerSetMember
//        label.font = .font(.regular, ofSize: 18)
//        label.textColor = .white
//        return label
//    }()
//    private lazy var minMemberLabel: UILabel = {
//        let label = UILabel()
//        label.text = "\(Int(self.memberSlider.minimumValue))인"
//        label.font = .font(.regular, ofSize: 16)
//        label.textColor = .white
//        return label
//    }()
//    private lazy var maxMemberLabel: UILabel = {
//        let label = UILabel()
//        label.text = "\(Int(self.memberSlider.maximumValue))인"
//        label.font = .font(.regular, ofSize: 16)
//        label.textColor = .white
//        return label
//    }()
//    private lazy var memberSlider: UISlider = {
//        let slider = UISlider()
//        slider.minimumValue = 4
//        slider.maximumValue = 15
//        slider.maximumTrackTintColor = .darkGrey003
//        slider.minimumTrackTintColor = .red001
//        slider.value = Float(self.sliderValue)
//        slider.isContinuous = true
//        slider.setThumbImage(ImageLiterals.imageSliderThumb, for: .normal)
//        return slider
//    }()
//    private lazy var memberCountLabel: UILabel = {
//        let label = UILabel()
//        label.text = "\(self.sliderValue)" + TextLiteral.per
//        label.font = .font(.regular, ofSize: 24)
//        label.textColor = .white
//        return label
//    }()
    
    // MARK: - property
    
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
//    var didTappedChangeButton: (() -> ())?
    private let roomIndex: Int
    private let roomTitle: String
    var editMode: EditMode
    var currentUserCount: Int = 0
    var sliderValue: Int = 10
    var startDateText: String = ""
//    {
//        didSet {
//            self.calendarView.startDateText = startDateText
//            self.calendarView.setupDateRange()
//        }
//    }
    var endDateText: String = ""
//    {
//        didSet {
//            self.calendarView.endDateText = endDateText
//            self.calendarView.setupDateRange()
//        }
//    }
    
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
    
    override func loadView() {
        self.view = self.detailEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.setupCalendarLayout()
    }
    
    override func configureUI() {
        super.configureUI()
        self.presentationController?.delegate = self
        self.isModalInPresentation = true
    }

    // MARK: - func

//    private func didTapChangeButton() {
//        let dto = RoomDTO(title: self.roomTitle,
//                          capacity: Int(self.memberSlider.value),
//                          startDate: "20\(self.calendarView.getTempStartDate())",
//                          endDate: "20\(self.calendarView.getTempEndDate())")
//        switch self.editMode {
//        case .date:
//            self.putChangeRoomInfo(roomDto: dto)
//        case .information:
//            if self.currentUserCount <= self.sliderValue {
//                self.putChangeRoomInfo(roomDto: dto)
//            } else {
//                self.makeAlert(title: TextLiteral.detailEditViewControllerChangeRoomInfoAlertTitle,
//                          message: TextLiteral.detailEditViewControllerChangeRoomInfoAlertMessage)
//            }
//        }
//    }
    
    private func configureDelegation() {
        self.detailEditView.configureDelegation(self)
    }
    
    private func setupCalendarLayout() {
        self.detailEditView.setupDateRange(from: self.startDateText, to: self.endDateText)
    }
    
    private func presentationControllerDidAttemptToDismissAlert() {
        guard self.detailEditView.calendarView.isFirstTap else {
            self.dismiss(animated: true)
            return
        }
        self.showDiscardActionSheet()
    }

    private func showDiscardActionSheet() {
        let actionTitles = [TextLiteral.destructive, TextLiteral.cancel]
        let actionStyle: [UIAlertAction.Style] = [.destructive, .cancel]
        let actions: [((UIAlertAction) -> Void)?] = [{ [weak self] _ in
            self?.dismiss(animated: true)
        }, nil]
        self.makeActionSheet(actionTitles: actionTitles,
                        actionStyle: actionStyle,
                        actions: actions)
    }
    
    // MARK: - network
    
    private func putChangeRoomInfo(roomDto: RoomDTO) {
        Task {
            do {
                let status = try await self.detailWaitService.editRoomInfo(roomId: "\(roomIndex)",
                                                                           roomInfo: roomDto)
                if status == 204 {
                    ToastView.showToast(message: "방 정보 수정 완료",
                                        view: self.view ?? UIView())
//                    self.didTappedChangeButton?()
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

extension DetailEditViewController: DetailEditDelegate {
    func dismiss() {
        self.dismiss(animated: true)
    }
    
    func changeRoomInformation(capacity: Int, from startDate: String, to endDate: String) {
        let dto = RoomDTO(title: self.roomTitle,
                          capacity: capacity,
                          startDate: "20\(startDate)",
                          endDate: "20\(endDate)")
        print(dto)
    }
}
