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
    private let viewModel: any BaseViewModelType
    weak var detailWaitDelegate: DetailWaitViewControllerDelegate?
    private var cancellable: Set<AnyCancellable> = Set()
    
    // MARK: - init
    
    init(editMode: DetailEditView.EditMode, 
         room: RoomInfo,
         viewModel: any BaseViewModelType) {
        self.detailEditView = DetailEditView(editMode: editMode, roomInfo: room)
        self.editMode = editMode
        self.viewModel = viewModel
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
        self.setupPresentationController()
        self.bindViewModel()
        self.bindUI()
    }

    // MARK: - func

    private func setupPresentationController() {
        self.presentationController?.delegate = self
        self.isModalInPresentation = true
    }
    
    private func setupRoomInfoView(roomInfo: RoomInfo) {
        let startDate = roomInfo.roomInformation.startDate
        let endDate = roomInfo.roomInformation.endDate
        let capacity = roomInfo.roomInformation.capacity
        
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
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> DetailEditViewModel.Output? {
        guard let viewModel = self.viewModel as? DetailEditViewModel else { return nil }
        let input = DetailEditViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            changeButtonDidTap: self.detailEditView.changeButtonSubject.eraseToAnyPublisher())
        
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: DetailEditViewModel.Output?) {
        guard let output else { return }
        
        output.roomInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] roomInfo in
                self?.setupRoomInfoView(roomInfo: roomInfo)
            })
            .store(in: &self.cancellable)
        
        output.isPassStartDate
            .receive(on: DispatchQueue.main)
            .filter { !$0 }
            .sink(receiveValue: { [weak self] _ in
                self?.showAlertPassedStartDate()
            })
            .store(in: &self.cancellable)
        
        output.isOverMember
            .receive(on: DispatchQueue.main)
            .filter { !$0 }
            .sink(receiveValue: { [weak self] _ in
                self?.showAlertOverMember()
            })
            .store(in: &self.cancellable)
        
        output.changeSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let statusCode):
                    if statusCode == 204 {
                        self?.detailWaitDelegate?.didTappedChangeButton()
                        self?.dismiss(animated: true)
                    }
                case .failure(let error):
                    self?.showErrorAlert(error.localizedDescription)
                }
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.detailEditView.cancelButtonPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &self.cancellable)
        
        self.detailEditView.calendarView.buttonStatePublisher
            .sink(receiveValue: { [weak self] value in
                self?.detailEditView.setupChangeButton(value)
            })
            .store(in: &self.cancellable)
    }
}


// MARK: - Helper
extension DetailEditViewController {
    private func showAlertPassedStartDate() {
        self.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                       message: TextLiteral.DetailEdit.Error.date.localized())
    }
    
    private func showAlertOverMember() {
        self.makeAlert(title: TextLiteral.DetailEdit.Error.memberTitle.localized(),
                       message: TextLiteral.DetailEdit.Error.memberMessage.localized())
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
