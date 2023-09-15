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
    
    private let deleteMenuButtonSubject = PassthroughSubject<Void, Never>()
    private let leaveMenuButtonSubject = PassthroughSubject<Void, Never>()
    private let changeButtonSubject = PassthroughSubject<Void, Never>()
    private var cancellable = Set<AnyCancellable>()
    private let detailWaitViewModel: DetailWaitViewModel
    
    // MARK: - init
    
    init(viewModel: DetailWaitViewModel) {
        self.detailWaitViewModel = viewModel
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
        self.configureNavigationController()
        self.bindViewModel()
        self.setupBind()
    }
    
    // MARK: - func
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didTapEnterButton), name: .createRoomInvitedCode, object: nil)
    }
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.detailWaitView.configureNavigationItem(navigationController)
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> DetailWaitViewModel.Output {
        let input = DetailWaitViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            codeCopyButtonDidTap: self.detailWaitView.copyButtonPublisher,
            startButtonDidTap: self.detailWaitView.startButtonPublisher,
            editMenuButtonDidTap: self.detailWaitView.editMenuButtonSubject.eraseToAnyPublisher(),
            deleteMenuButtonDidTap: self.deleteMenuButtonSubject.eraseToAnyPublisher(),
            leaveMenuButtonDidTap: self.leaveMenuButtonSubject.eraseToAnyPublisher(),
            changeButtonDidTap: self.changeButtonSubject.eraseToAnyPublisher())
        return self.detailWaitViewModel.transform(input)
    }
    
    private func bindOutputToViewModel(_ output: DetailWaitViewModel.Output) {
        output.roomInformation
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    // FIXME: - 에러 관련 부분 수정 필요
                    self?.makeAlert(title: "에러 발생")
                }
            }, receiveValue: { [weak self] room in
                self?.detailWaitView.updateDetailWaitView(room: room)
            })
            .store(in: &self.cancellable)
        
        output.code
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] code in
                self?.showToastView(code: code)
            })
            .store(in: &self.cancellable)
        
        output.manitteeNickname
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    // FIXME: - 에러 관련 부분 수정 필요
                    self?.makeAlert(title: "에러 발생")
                }
            }, receiveValue: { [weak self] nickname in
                self?.presentSelectManittoViewController(nickname: nickname)
            })
            .store(in: &self.cancellable)
        
        output.editRoomInformation
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] editInformation in
                self?.showDetailEditViewController(roomInformation: editInformation.roomInformation,
                                                   mode: editInformation.mode)
            })
            .store(in: &self.cancellable)
        
        output.deleteRoom
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    // FIXME: - 에러 관련 부분 수정 필요
                    self?.makeAlert(title: "오류 발생")
                }
            }, receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &self.cancellable)
        
        output.leaveRoom
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    // FIXME: - 에러 관련 부분 수정 필요
                    self?.makeAlert(title: "오류 발생")
                }
            }, receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &self.cancellable)
        
        output.passedStartDate
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (isPassedStartDate, isAdmin) in
                self?.showStartDatePassedAlert(isPassedStartDate: isPassedStartDate, isAdmin: isAdmin)
            })
            .store(in: &self.cancellable)
    }
    
    private func setupBind() {
        self.detailWaitView.deleteMenuButtonSubject
            .sink(receiveValue: { [weak self] _ in
                self?.deleteRoom()
            })
            .store(in: &self.cancellable)
        
        self.detailWaitView.leaveMenuButtonSubject
            .sink(receiveValue: { [weak self] _ in
                self?.leaveRoom()
            })
            .store(in: &self.cancellable)
    }
        
    private func showDetailEditViewController(roomInformation: RoomInfo, mode: DetailEditView.EditMode) {
        let viewController = DetailEditViewController(editMode: mode, room: roomInformation)
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
    
    private func deleteRoom() {
        self.makeRequestAlert(title: TextLiteral.datailWaitViewControllerDeleteTitle,
                              message: TextLiteral.datailWaitViewControllerDeleteMessage,
                              okTitle: TextLiteral.delete,
                              okAction: { [weak self] _ in
            self?.deleteMenuButtonSubject.send(())
        })
    }
    
    private func leaveRoom() {
        self.makeRequestAlert(title: TextLiteral.datailWaitViewControllerExitTitle,
                              message: TextLiteral.datailWaitViewControllerExitMessage,
                              okTitle: TextLiteral.leave,
                              okAction: { [weak self] _ in
            self?.leaveMenuButtonSubject.send(())
        })
    }
    
    private func showStartDatePassedAlert(isPassedStartDate: Bool, isAdmin: Bool) {
        guard isPassedStartDate else { return }
        self.makeAlert(
            title: isAdmin
            ? TextLiteral.detailWaitViewControllerPastAlertTitle
            : TextLiteral.detailWaitViewControllerPastAlertTitle,
            message: isAdmin
            ? TextLiteral.detailWaitViewControllerPastAdminAlertMessage
            : TextLiteral.detailWaitViewControllerPastAlertMessage,
            okAction: isAdmin
            ? { [weak self] _ in
                guard let roomInformaion = self?.detailWaitViewModel.makeRoomInformation() else { return }
                self?.showDetailEditViewController(roomInformation: roomInformaion, mode: .date)
            }
            : nil
        )
    }
    
    // MARK: - selector
    
    @objc
    private func didTapEnterButton() {
        let roomInfo = self.detailWaitViewModel.makeRoomInformation()
        let title = roomInfo.roomInformation.title
        let capacity = roomInfo.roomInformation.capacity
        let startDate = roomInfo.roomInformation.startDate
        let endDate = roomInfo.roomInformation.endDate
        let invitationCode = roomInfo.invitation.code
        let roomDTO = RoomListItemDTO(id: nil,
                                      title: title,
                                      state: nil,
                                      participatingCount: nil,
                                      capacity: capacity,
                                      startDate: startDate,
                                      endDate: endDate)
        let viewController = InvitedCodeViewController(roomInfo: roomDTO,
                                                       code: invitationCode)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
}

extension DetailWaitViewController: DetailWaitViewControllerDelegate {
    func didTappedChangeButton() {
        self.changeButtonSubject.send()
        ToastView.showToast(message: TextLiteral.detailWaitToastEditMessage,
                            controller: self)
    }
}
