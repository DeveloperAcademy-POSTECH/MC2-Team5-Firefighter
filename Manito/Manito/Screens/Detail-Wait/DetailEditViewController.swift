//
//  DetailHalfModalController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/13.
//

import UIKit

import SnapKit

final class DetailEditViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let detailEditView: DetailEditView
    
    // MARK: - property
    
    private let editMode: DetailEditView.EditMode
    private let detailRoomRepository: DetailRoomRepository = DetailRoomRepositoryImpl()
    private let room: RoomInfo
    weak var detailWaitDelegate: DetailWaitViewControllerDelegate?
    
    // MARK: - init
    
    init(editMode: DetailEditView.EditMode, room: RoomInfo) {
        self.detailEditView = DetailEditView(editMode: editMode)
        self.editMode = editMode
        self.room = room
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.detailEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPresentationController()
        self.configureDelegation()
        self.setupCalendarDateRange()
        if self.editMode == .information {
            self.setupMemberSliderValue()
        }
    }

    // MARK: - func

    private func setupPresentationController() {
        self.presentationController?.delegate = self
        self.isModalInPresentation = true
    }
    
    private func configureDelegation() {
        self.detailEditView.configureDelegation(self)
        self.detailEditView.configureCalendarDelegate(self)
    }
    
    private func setupCalendarDateRange() {
        let startDate = self.room.roomInformation.startDate
        let endDate = self.room.roomInformation.endDate
        self.detailEditView.setupDateRange(from: startDate, to: endDate)
    }
    
    private func setupMemberSliderValue() {
        let capacity = self.room.roomInformation.capacity
        self.detailEditView.setupSliderValue(capacity)
    }
    
    private func presentationControllerDidAttemptToDismissAlert() {
        guard self.detailEditView.calendarView.isFirstTap else {
            self.dismiss(animated: true)
            return
        }
        self.showDiscardActionSheet()
    }

    private func showDiscardActionSheet() {
        let actionTitles = [TextLiteral.Common.discardChanges.localized(),
                            TextLiteral.Common.cancel.localized()]
        let actionStyle: [UIAlertAction.Style] = [.destructive, .cancel]
        let actions: [((UIAlertAction) -> Void)?] = [{ [weak self] _ in
            self?.dismiss(animated: true)
        }, nil]
        self.makeActionSheet(actionTitles: actionTitles,
                        actionStyle: actionStyle,
                        actions: actions)
    }
    
    // MARK: - network
    
    private func putRoomInfo(roomDTO: CreatedRoomInfoRequestDTO, completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        let roomIndex = self.room.roomInformation.id
        Task {
            do {
                let status = try await self.detailRoomRepository.putRoomInfo(roomId: roomIndex.description,
                                                                             roomInfo: roomDTO)
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
    func cancelButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    func changeButtonDidTap(capacity: Int, from startDate: String, to endDate: String) {
        let roomTitle = self.room.roomInformation.title
        let currentUserCount = self.room.participants.count
        let dto = CreatedRoomInfoRequestDTO(title: roomTitle,
                                            capacity: capacity,
                                            startDate: "20\(startDate)",
                                            endDate: "20\(endDate)")
        if currentUserCount <= capacity {
            self.putRoomInfo(roomDTO: dto) { [weak self] result in
                switch result {
                case .success:
                    self?.detailWaitDelegate?.didTappedChangeButton()
                    self?.cancelButtonDidTap()
                case .failure:
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                                    message: TextLiteral.DetailEdit.Error.message.localized()
                    )
                }
            }
        } else {
            self.makeAlert(title: TextLiteral.DetailEdit.Error.memberTitle.localized(),
                           message: TextLiteral.DetailEdit.Error.memberMessage.localized())
        }
    }
}

extension DetailEditViewController: CalendarDelegate {
    func detectChangeButton(_ value: Bool) {
        self.detailEditView.setupChangeButton(value)
    }
}
