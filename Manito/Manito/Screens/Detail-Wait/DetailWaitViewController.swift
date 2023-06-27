//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/04/15.
//

import Combine
import UIKit

import SnapKit

protocol DetailWaitViewControllerDelegate: AnyObject {
    func didTappedChangeButton()
}

final class DetailWaitViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let detailWaitView = DetailWaitView()
    
    // MARK: - property
    
    private var cancellable = Set<AnyCancellable>()
    private let detailWaitViewModel: DetailWaitViewModel
    
    // MARK: - init
    
    init(roomIndex: Int) {
        self.detailWaitViewModel = DetailWaitViewModel(roomIndex: roomIndex, detailWaitService: DetailWaitAPI(apiService: APIService()))
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
        self.view = self.detailWaitView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNotificationCenter()
        self.configureDelegation()
        self.configureNavigationController()
        self.fetchRoomInformationAtViewModel()
        self.setupBindings()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.detailWaitView.configureDelegation(self)
    }
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.detailWaitView.configureNavigationItem(navigationController)
    }
    
    private func fetchRoomInformationAtViewModel() {
        self.detailWaitViewModel.fetchRoomInformation()
    }
    
    private func setupBindings() {
        let input = DetailWaitViewModel.Input(
            codeCopyButtonDidTap: self.detailWaitView.copyButton.tapPublisher,
            startButtonDidTap: self.detailWaitView.startButton.tapPublisher
        )
        let output = self.detailWaitViewModel.transform(input)
        
        output.roomInformationDidUpdate
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] room in
                if let room {
                    self?.detailWaitView.updateDetailWaitView(room: room)
                }
            })
            .store(in: &self.cancellable)
        
        output.showToast
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] code in
                self?.showToastView(code: code)
            })
            .store(in: &self.cancellable)
        
        output.startManitto
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.startManitto()
            })
            .store(in: &self.cancellable)
        
        output.presentEditView
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.presentDetailEditViewController(isOnlyDateEdit: false)
            })
            .store(in: &self.cancellable)
        
        output.deleteRoom
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.deleteRoom()
            })
            .store(in: &self.cancellable)
        
        output.leaveRoom
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.leaveRoom()
            })
            .store(in: &self.cancellable)
        
        output.showStartDatePassedAlert
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.showStartDatePassedAlert(isAdmin: value)
            })
            .store(in: &self.cancellable)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didTapEnterButton), name: .createRoomInvitedCode, object: nil)
    }
    
    private func presentDetailEditViewController(isOnlyDateEdit: Bool) {
        guard let roominformation = self.detailWaitViewModel.roomInformation.value else { return }
        let viewController = DetailEditViewController(editMode: isOnlyDateEdit ? .date : .information,
                                                      room: roominformation)
        viewController.detailWaitDelegate = self
        self.present(viewController, animated: true)
    }
    
    private func presentSelectManittoViewController(nickname: String) {
        let roomIndex = self.detailWaitViewModel.roomIndex.description
        let viewController = SelectManitteeViewController(roomId: roomIndex, manitteeNickname: nickname)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    private func showToastView(code: String) {
        ToastView.showToast(code: code,
                            message: TextLiteral.detailWaitViewControllerCopyCode,
                            controller: self)
    }
    
    private func startManitto() {
        self.detailWaitViewModel.requestStartManitto() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nickname):
                    self?.presentSelectManittoViewController(nickname: nickname)
                case .failure:
                    self?.makeAlert(title: TextLiteral.errorAlertTitle,
                                    message: TextLiteral.detailWaitViewControllerStartErrorMessage)
                }
            }
        }
    }
    
    private func deleteRoom() {
        self.makeRequestAlert(title: TextLiteral.datailWaitViewControllerDeleteTitle,
                              message: TextLiteral.datailWaitViewControllerDeleteMessage,
                              okTitle: TextLiteral.delete,
                              okAction: { [weak self] _ in
            self?.detailWaitViewModel.requestDeleteRoom() { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.navigationController?.popViewController(animated: true)
                    case .failure:
                        self?.makeAlert(title: TextLiteral.errorAlertTitle,
                                        message: TextLiteral.detailWaitViewControllerDeleteErrorMessage)
                    }
                }
            }
        })
    }
    
    private func leaveRoom() {
        self.makeRequestAlert(title: TextLiteral.datailWaitViewControllerExitTitle,
                              message: TextLiteral.datailWaitViewControllerExitMessage,
                              okTitle: TextLiteral.leave,
                              okAction: { [weak self] _ in
            self?.detailWaitViewModel.requestDeleteLeaveRoom() { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.navigationController?.popViewController(animated: true)
                    case .failure:
                        self?.makeAlert(title: TextLiteral.errorAlertTitle,
                                        message: TextLiteral.detailWaitViewControllerLeaveErrorMessage)
                    }
                }
            }
        })
    }
    
    private func showStartDatePassedAlert(isAdmin: Bool) {
        if isAdmin {
            self.makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle,
                           message: TextLiteral.detailWaitViewControllerPastAdminAlertMessage,
                           okAction: { [weak self] _ in
                self?.presentDetailEditViewController(isOnlyDateEdit: true) }
            )
        } else {
            self.makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle,
                           message: TextLiteral.detailWaitViewControllerPastAlertMessage)
        }
    }
    
    // MARK: - selector
    
    @objc
    private func didTapEnterButton() {
        guard let roomInfo = self.detailWaitViewModel.roomInformation.value,
              let title = roomInfo.roomInformation?.title,
              let capacity = roomInfo.roomInformation?.capacity,
              let startDate = roomInfo.roomInformation?.startDate,
              let endDate = roomInfo.roomInformation?.endDate,
              let invitationCode = roomInfo.invitation?.code
        else { return }
        let roomDto = RoomDTO(title: title,
                              capacity: capacity,
                              startDate: startDate,
                              endDate: endDate)
        let viewController = InvitedCodeViewController(roomInfo: roomDto,
                                                       code: invitationCode)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
}

extension DetailWaitViewController: DetailWaitViewDelegate {
    func editButtonDidTap() {
        self.detailWaitViewModel.editMenuButtonDidTap.send(())
    }
    
    func deleteButtonDidTap() {
        self.detailWaitViewModel.deleteMenuButtonDidTap.send(())
    }
    
    func leaveButtonDidTap() {
        self.detailWaitViewModel.leaveMenuButtonDidTap.send(())
    }
    
    func didPassStartDate(isAdmin: Bool) {
        self.detailWaitViewModel.didPassedStartDate.send(isAdmin)
    }
}

extension DetailWaitViewController: DetailWaitViewControllerDelegate {
    func didTappedChangeButton() {
        self.detailWaitViewModel.fetchRoomInformation()
        ToastView.showToast(message: "방 정보 수정 완료",
                            controller: self)
    }
}
