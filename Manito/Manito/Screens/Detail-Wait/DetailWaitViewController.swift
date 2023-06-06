//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/04/15.
//

import Combine
import UIKit

import SnapKit

final class DetailWaitViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let detailWaitView = DetailWaitView()
    
    // MARK: - property
    
    private var cancleable = Set<AnyCancellable>()
    private lazy var viewModel = DetailWaitViewModel(roomIndex: self.roomIndex, detailWaitService: DetailWaitAPI(apiService: APIService()))
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    private let roomIndex: Int
    private var roomInformation: Room?
    
    // MARK: - init
    
    init(roomIndex: Int) {
        self.roomIndex = roomIndex
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
        self.bind()
        self.viewModel.fetchRoomInformation()
    }
    
    // MARK: - func
    
    private func bind() {
        self.viewModel.$roomInformation
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
            switch result {
            case .finished:
                print("finish")
            case .failure:
                print("error")
            }
        }, receiveValue: { room in
            if let room {
                self.detailWaitView.updateDetailWaitView(room: room)
            }
        })
            .store(in: &self.cancleable)
    }
    
    private func configureDelegation() {
        self.detailWaitView.configureDelegation(self)
    }
    
    private func presentDetailEditViewController(isOnlyDateEdit: Bool) {
        guard let room = self.roomInformation,
              let index = room.roomInformation?.id,
              let title = room.roomInformation?.title,
              let currentUserCount = room.participants?.count,
              let capacity = room.roomInformation?.capacity else { return }
        let viewController = DetailEditViewController(editMode: isOnlyDateEdit ? .date : .information,
                                                      roomIndex: index,
                                                      title: title)
        
        guard let startDate = room.roomInformation?.dateRange.startDate,
              let endDate = room.roomInformation?.dateRange.endDate else { return }
        
        viewController.startDateText = startDate
        viewController.endDateText = endDate
        viewController.currentUserCount = currentUserCount
        viewController.sliderValue = capacity
        self.present(viewController, animated: true)
    }
    
    private func checkStartDateIsPast(_ startDate: String) -> Bool {
        guard let startDate = startDate.stringToDate else { return false }
        return startDate.isPast
    }
    
    private func presentSelectManittoViewController(nickname: String) {
        guard let roomId = self.roomInformation?.roomInformation?.id?.description else { return }
        let viewController = SelectManitteeViewController(roomId: roomId, manitteeNickname: nickname)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.detailWaitView.configureNavigationItem(navigationController)
    }
    
    private func requestStartManitto(completionHandler: @escaping ((Result<String, NetworkError>) -> Void)) {
        Task {
            do {
                let data = try await self.detailWaitService.startManitto(roomId: self.roomIndex.description)
                if let manittee = data {
                    guard let nickname = manittee.nickname else { return }
                    completionHandler(.success(nickname))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
    
    private func requestDeleteRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteRoom(roomId: self.roomIndex.description)
                switch statusCode {
                case 200..<300: completionHandler(.success(()))
                default:
                    completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
    
    private func requestDeleteLeaveRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteLeaveRoom(roomId: self.roomIndex.description)
                switch statusCode {
                case 200..<300: completionHandler(.success(()))
                default: completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
}

extension DetailWaitViewController: DetailWaitViewDelegate {
    func startButtonDidTap() {
        self.requestStartManitto() { [weak self] result in
            switch result {
            case .success(let nickname):
                self?.presentSelectManittoViewController(nickname: nickname)
            case .failure:
                self?.makeAlert(title: TextLiteral.errorAlertTitle,
                                message: TextLiteral.detailWaitViewControllerStartErrorMessage)
            }
        }
    }
    
    func editButtonDidTap(isOnlyDateEdit: Bool) {
        self.presentDetailEditViewController(isOnlyDateEdit: isOnlyDateEdit)
    }
    
    func deleteButtonDidTap(title: String, message: String, okTitle: String) {
        self.makeRequestAlert(title: title,
                              message: message,
                              okTitle: okTitle,
                              okAction: { [weak self] _ in
            self?.requestDeleteRoom() { result in
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case .failure:
                    self?.makeAlert(title: TextLiteral.errorAlertTitle,
                                    message: TextLiteral.detailWaitViewControllerDeleteErrorMessage)
                }
            }
        })
    }
    
    func leaveButtonDidTap(title: String, message: String, okTitle: String) {
        self.makeRequestAlert(title: title,
                              message: message,
                              okAction: { [weak self] _ in
            self?.requestDeleteLeaveRoom() { result in
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case .failure:
                    self?.makeAlert(title: TextLiteral.errorAlertTitle,
                                    message: TextLiteral.detailWaitViewControllerLeaveErrorMessage)
                }
            }
        })
    }
    
    func codeCopyButtonDidTap() {
        guard let invitationCode = self.viewModel.roomInformation?.invitation?.code else { return }
        ToastView.showToast(code: invitationCode,
                            message: TextLiteral.detailWaitViewControllerCopyCode,
                            controller: self)
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
