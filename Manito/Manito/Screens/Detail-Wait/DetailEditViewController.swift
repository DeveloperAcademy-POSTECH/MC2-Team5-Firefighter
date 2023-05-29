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
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    var didTappedChangeButton: (() -> ())?
    private let room: Room
    
    // MARK: - init
    
    init(editMode: DetailEditView.EditMode, room: Room) {
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
        self.configureDelegation()
        self.setupCalendarDateRange()
        if self.editMode == .information {
            self.setupMemberSliderValue()
        }
    }
    
    // MARK: - override
    
    override func configureUI() {
        super.configureUI()
        self.presentationController?.delegate = self
        self.isModalInPresentation = true
    }

    // MARK: - func
    
    private func configureDelegation() {
        self.detailEditView.configureDelegation(self)
    }
    
    private func setupCalendarDateRange() {
        guard let startDate = self.room.roomInformation?.startDate,
              let endDate = self.room.roomInformation?.endDate else { return }
        self.detailEditView.setupDateRange(from: startDate, to: endDate)
    }
    
    private func setupMemberSliderValue() {
        guard let capacity = self.room.roomInformation?.capacity else { return }
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
    
    private func putRoomInfo(roomDto: RoomDTO, completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        guard let roomIndex = self.room.roomInformation?.id else { return }
        Task {
            do {
                let status = try await self.detailWaitService.editRoomInfo(roomId: roomIndex.description,
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
    func cancleButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    func changeButtonDidTap(capacity: Int, from startDate: String, to endDate: String) {
        guard let roomTitle = self.room.roomInformation?.title,
              let currentUserCount = self.room.participants?.count else { return }
        let dto = RoomDTO(title: roomTitle,
                          capacity: capacity,
                          startDate: "20\(startDate)",
                          endDate: "20\(endDate)")
        if currentUserCount <= capacity {
            self.putRoomInfo(roomDto: dto) { [weak self] result in
                switch result {
                case .success:
                    self?.didTappedChangeButton?()
                    self?.cancleButtonDidTap()
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
