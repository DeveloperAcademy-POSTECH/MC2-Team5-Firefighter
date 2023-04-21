//
//  DetailHalfModalController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/13.
//

import UIKit

import SnapKit

final class DetailEditViewController: BaseViewController {
    
    enum EditMode {
        case date
        case information
    }

    // MARK: - ui component
    
    private lazy var detailEditView = DetailEditView(maximumMemberCount: self.sliderValue)
    
    // MARK: - property
    
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    var didTappedChangeButton: (() -> ())?
    private let roomIndex: Int
    private let roomTitle: String
    var editMode: EditMode
    var currentUserCount: Int = 0
    var sliderValue: Int = 10
    var startDateText: String = ""
    var endDateText: String = ""
    
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
    
    private func putChangeRoomInfo(roomDto: RoomDTO, completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let status = try await self.detailWaitService.editRoomInfo(roomId: "\(roomIndex)",
                                                                           roomInfo: roomDto)
                switch status {
                case 200..<300:
                    completionHandler(.success(()))
                default:
                    completionHandler(.failure((.unknownError)))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
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
        if self.currentUserCount <= capacity {
            self.putChangeRoomInfo(roomDto: dto) { [weak self] result in
                switch result {
                case .success:
                    // FIXME: - 토스트 고장
                    ToastView.showToast(message: "방 정보 수정 완료",
                                        controller: self ?? UIViewController())
                    self?.didTappedChangeButton?()
                    self?.dismiss()
                case .failure:
                    self?.makeAlert(title: TextLiteral.detailEditViewControllerChangeErrorTitle,
                                    message: TextLiteral.detailEditViewControllerChangeErrorMessage
                    )
                }
            }
        } else {
            self.makeAlert(title: TextLiteral.detailEditViewControllerChangeRoomInfoAlertTitle,
                           message: TextLiteral.detailEditViewControllerChangeRoomInfoAlertMessage)
        }
    }
}
