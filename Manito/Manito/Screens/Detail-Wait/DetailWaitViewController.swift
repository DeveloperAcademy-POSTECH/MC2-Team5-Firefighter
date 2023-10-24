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

final class DetailWaitViewController: UIViewController, Navigationable {
    
    // MARK: - ui component
    
    private let detailWaitView = DetailWaitView()
    
    // MARK: - property
    
    private let createRoomSubject = PassthroughSubject<Void, Never>()
    private let deleteMenuButtonSubject = PassthroughSubject<Void, Never>()
    private let leaveMenuButtonSubject = PassthroughSubject<Void, Never>()
    private let changeButtonSubject = PassthroughSubject<Void, Never>()
    private var cancellable = Set<AnyCancellable>()
    private let detailWaitViewModel: DetailWaitViewModel
    
    // MARK: - init
    
    init(viewModel: DetailWaitViewModel) {
        self.detailWaitViewModel = viewModel
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
        self.view = self.detailWaitView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.configureNavigationController()
        self.bindViewModel()
        self.setupBind()
    }
    
    // MARK: - func
    
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
            changeButtonDidTap: self.changeButtonSubject.eraseToAnyPublisher(),
            roomDidCreate: self.createRoomSubject.eraseToAnyPublisher()
        )
        return self.detailWaitViewModel.transform(input)
    }
    
    private func bindOutputToViewModel(_ output: DetailWaitViewModel.Output) {
        output.roomInformation
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(let error):
                    self?.showAlertError(message: error.localizedDescription,
                                         okAction: { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }, receiveValue: { [weak self] result in
                switch result {
                case .success(let roomInfo):
                    self?.detailWaitView.updateDetailWaitView(room: roomInfo)
                case .failure(let error):
                    self?.showAlertError(message: error.localizedDescription,
                                         okAction: { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            })
            .store(in: &self.cancellable)
        
        output.code
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] code in
                self?.showToastView(code: code)
            })
            .store(in: &self.cancellable)
        
        output.selectManitteeInfo
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(let error):
                    self?.showAlertError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] data in
                guard let nickname = data.userInfo?.nickname,
                      let roomId = data.roomId else { return }
                self?.presentSelectManittoViewController(nickname: nickname, roomId: roomId)
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
                case .failure(let error):
                    self?.showAlertError(message: error.localizedDescription)
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
                case .failure(let error):
                    self?.showAlertError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &self.cancellable)
        
        output.passedStartDate
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized())
                }
            }, receiveValue: { [weak self] (isPassedStartDate, isAdmin) in
                self?.showStartDatePassedAlert(isPassedStartDate: isPassedStartDate, isAdmin: isAdmin)
            })
            .store(in: &self.cancellable)
        
        output.invitedCodeView
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized())
                }
            }, receiveValue: { [weak self] roomInfo in
                self?.showInvitedCodeView(roomInfo: roomInfo)
            })
            .store(in: &self.cancellable)
        
        output.changeOutput
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: return
                case .failure(_):
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized())
                }
            }, receiveValue: { [weak self] roomInfo in
                self?.detailWaitView.updateDetailWaitView(room: roomInfo)
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
    
    private func presentSelectManittoViewController(nickname: String, roomId: String) {
        let viewModel = SelectManitteeViewModel(roomId: roomId, manitteeNickname: nickname)
        let viewController = SelectManitteeViewController(viewModel: viewModel)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    private func showToastView(code: String) {
        ToastView.showToast(code: code,
                            message: TextLiteral.DetailWait.toastCopyMessage.localized(),
                            controller: self)
    }
    
    private func deleteRoom() {
        self.makeRequestAlert(title: TextLiteral.DetailWait.deleteAlertTitle.localized(),
                              message: TextLiteral.DetailWait.deleteAlertMessage.localized(),
                              okTitle: TextLiteral.Detail.delete.localized(),
                              okAction: { [weak self] _ in
            self?.deleteMenuButtonSubject.send(())
        })
    }
    
    private func leaveRoom() {
        self.makeRequestAlert(title: TextLiteral.DetailWait.exitAlertTitle.localized(),
                              message: TextLiteral.DetailWait.exitAlertMessage.localized(),
                              okTitle: TextLiteral.Detail.leave.localized(),
                              okAction: { [weak self] _ in
            self?.leaveMenuButtonSubject.send(())
        })
    }
    
    private func showStartDatePassedAlert(isPassedStartDate: Bool, isAdmin: Bool) {
        guard isPassedStartDate else { return }
        self.makeAlert(
            title: TextLiteral.DetailWait.pastAlertTitle.localized(),
            message: isAdmin
            ? TextLiteral.DetailWait.pastAdminAlertMessage.localized()
            : TextLiteral.DetailWait.pastAlertMessage.localized(),
            okAction: isAdmin
            ? { [weak self] _ in
                guard let roomInformaion = self?.detailWaitViewModel.makeRoomInformation() else { return }
                self?.showDetailEditViewController(roomInformation: roomInformaion, mode: .date)
            }
            : nil
        )
    }
    
    private func showInvitedCodeView(roomInfo: RoomInfo) {
        let roomListItem = roomInfo.roomInformation
        let code = roomInfo.invitation.code
        
        let viewController = InvitedCodeViewController(roomInfo: roomListItem, code: code)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    func sendCreateRoomEvent() {
        self.createRoomSubject.send(())
    }
}

extension DetailWaitViewController: DetailWaitViewControllerDelegate {
    func didTappedChangeButton() {
        self.changeButtonSubject.send()
        ToastView.showToast(message: TextLiteral.DetailWait.toastEditMessage.localized(),
                            controller: self)
    }
}

extension DetailWaitViewController {
    private func showAlertError(message: String, okAction: ((UIAlertAction) -> ())? = nil) {
        self.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                       message: message,
                       okAction: okAction
        )
    }
}
