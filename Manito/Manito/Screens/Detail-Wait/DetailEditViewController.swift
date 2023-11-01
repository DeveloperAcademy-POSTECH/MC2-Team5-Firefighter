//
//  DetailHalfModalController.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/13.
//

import Combine
import UIKit

import SnapKit

final class DetailEditViewController: UIViewController {
    
    // MARK: - ui component
    
    private let detailEditView: DetailEditView
    
    // MARK: - property
    
    private let editMode: DetailEditView.EditMode
    private var roomPublisher: CurrentValueSubject<CreatedRoomInfoRequestDTO, Never>
    private let viewModel: any BaseViewModelType
    weak var detailWaitDelegate: DetailWaitViewControllerDelegate?
    private var cancellable = Set<AnyCancellable>()
    private var viewModelOutput: DetailEditViewModel.Output?
    
    // MARK: - init
    
    init(editMode: DetailEditView.EditMode, room: RoomInfo, viewModel: any BaseViewModelType) {
        self.detailEditView = DetailEditView(editMode: editMode)
        self.editMode = editMode
        self.viewModel = viewModel
        self.roomPublisher = .init(CreatedRoomInfoRequestDTO(title: room.roomInformation.title,
                                                             capacity: room.roomInformation.capacity,
                                                             startDate: room.roomInformation.startDate,
                                                             endDate: room.roomInformation.endDate))
        super.init(nibName: nil, bundle: nil)
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
        self.updateView(roomInfo: self.roomPublisher.value)
        self.setupPresentationController()
        self.configureDelegation()
        self.bindViewModel()
        self.bindUI()
    }

    // MARK: - func

    private func setupPresentationController() {
        self.presentationController?.delegate = self
        self.isModalInPresentation = true
    }
    
    private func configureDelegation() {
        self.detailEditView.configureCalendarDelegate(self)
    }
    
    private func updateView(roomInfo: CreatedRoomInfoRequestDTO) {
        let startDate = roomInfo.startDate
        let endDate = roomInfo.endDate
        let capacity = roomInfo.capacity
        
        self.setupCalendarDateRange(startDate: startDate, endDate: endDate)
        self.setupMemberSliderValue(capacity: capacity)
    }
    
    private func setupCalendarDateRange(startDate: String, endDate: String) {
        self.detailEditView.setupDateRange(from: startDate, to: endDate)
    }
    
    private func setupMemberSliderValue(capacity: Int) {
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
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.viewModelOutput = output
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> DetailEditViewModel.Output? {
        guard let viewModel = self.viewModel as? DetailEditViewModel else { return nil }
        let input = DetailEditViewModel.Input(
            changeRoomPublisher: self.roomPublisher.eraseToAnyPublisher(),
            changeButtonDidTap: self.detailEditView.changeButtonPublisher)
        
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: DetailEditViewModel.Output?) {
        guard let output else { return }
        
        output.passStartDate
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.showAlertPassedStartDate(value)
            })
            .store(in: &self.cancellable)
        
        output.overMember
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.showAlertOverMember(value)
            })
            .store(in: &self.cancellable)
        
        output.changeSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(let error):
                    self?.showErrorAlert(error.localizedDescription)
                }
            }, receiveValue: { [weak self] statusCode in
                switch statusCode {
                case 200..<300:
                    self?.detailWaitDelegate?.didTappedChangeButton()
                    self?.dismiss(animated: true)
                default:
                    return
                }
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.bindCalendar()
        self.bindSlider()
        self.bindCancleButton()
    }
    
    private func bindCalendar() {
        let calendarView = self.detailEditView.calendarView
        let calendarPublisher = calendarView.startDateTapPublisher.zip(calendarView.endDateTapPublisher)
        calendarPublisher
            .sink(receiveValue: { [weak self] startDate, endDate in
                guard let room = self?.roomPublisher.value else { return }
                let dto = CreatedRoomInfoRequestDTO(title: room.title,
                                                    capacity: room.capacity,
                                                    startDate: startDate,
                                                    endDate: endDate)
                self?.roomPublisher.send(dto)
            })
            .store(in: &self.cancellable)
    }
    
    private func bindSlider() {
        self.detailEditView.sliderPublisher
            .sink(receiveValue: { [weak self] value in
                guard let room = self?.roomPublisher.value else { return }
                let dto = CreatedRoomInfoRequestDTO(title: room.title,
                                                    capacity: Int(value),
                                                    startDate: room.startDate,
                                                    endDate: room.endDate)
                self?.roomPublisher.send(dto)
            })
            .store(in: &self.cancellable)
    }
    
    private func bindCancleButton() {
        self.detailEditView.cancleButtonPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &self.cancellable)
    }
}


// MARK: - Helper
extension DetailEditViewController {
    private func showAlertPassedStartDate(_ value: Bool) {
        if !value {
            self.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                            message: TextLiteral.DetailEdit.Error.memberMessage.localized())
        }
    }
    
    private func showAlertOverMember(_ value: Bool) {
        if !value {
            self.makeAlert(title: TextLiteral.DetailEdit.Error.memberTitle.localized(),
                           message: TextLiteral.DetailEdit.Error.memberMessage.localized())
        }
    }
    
    private func showErrorAlert(_ text: String) {
        self.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                       message: text)
    }
}

extension DetailEditViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.presentationControllerDidAttemptToDismissAlert()
    }
}

extension DetailEditViewController: CalendarDelegate {
    func detectChangeButton(_ value: Bool) {
        self.detailEditView.setupChangeButton(value)
    }
}
