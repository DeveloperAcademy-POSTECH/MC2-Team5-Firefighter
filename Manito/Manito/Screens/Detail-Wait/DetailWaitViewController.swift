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
    
    private var cancleable = Set<AnyCancellable>()
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
        self.configureDelegation()
        self.configureNavigationController()
        self.detailWaitViewModel.fetchRoomInformation()
        self.setBind()
    }
    
    // MARK: - func
    
    private func setBind() {
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
            .store(in: &self.cancleable)
        
        output.showToast
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] code in
                self?.showToastView(code: code)
            })
            .store(in: &self.cancleable)
        
        output.startManitto
            .receive(on: DispatchQueue.main)
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .sink(receiveValue: { [weak self] _ in
                self?.startManitto()
            })
            .store(in: &self.cancleable)
        
        self.detailWaitViewModel.editButtonDidTap
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.presentDetailEditViewController(isOnlyDateEdit: false)
            })
            .store(in: &self.cancleable)
        
        self.detailWaitViewModel.deleteButtonDidTap
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.deleteRoom()
            })
            .store(in: &self.cancleable)
        
        self.detailWaitViewModel.leaveButtonDidTap
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.leaveRoom()
            })
            .store(in: &self.cancleable)
    }
    
    private func configureDelegation() {
        self.detailWaitView.configureDelegation(self)
    }
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.detailWaitView.configureNavigationItem(navigationController)
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
}

extension DetailWaitViewController: DetailWaitViewDelegate {
    func editButtonDidTap() {
        self.detailWaitViewModel.editButtonDidTap.send(())
    }
    
    func deleteButtonDidTap() {
        self.detailWaitViewModel.deleteButtonDidTap.send(())
    }
    
    func leaveButtonDidTap() {
        self.detailWaitViewModel.leaveButtonDidTap.send(())
    }
    
    func codeCopyButtonDidTap() {
        // delegate 삭제 예정
    }
    
    func didPassStartDate(isAdmin: Bool) {
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
}

extension DetailWaitViewController: DetailWaitViewControllerDelegate {
    func didTappedChangeButton() {
        self.detailWaitViewModel.fetchRoomInformation()
        ToastView.showToast(message: "방 정보 수정 완료",
                            controller: self)
    }
}
