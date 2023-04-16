//
//  DetailWaitViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class DetailWaitViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let detailWaitView = DetailWaitView()
    
    // MARK: - property
    
    private let detailWaitService: DetailWaitAPI = DetailWaitAPI(apiService: APIService())
    private let roomIndex: Int

    // MARK: - init
    
    init(index: Int) {
        self.roomIndex = index
        super.init()
    }
    
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
        self.requestWaitRoomInfo()
        self.configureDelegation()
        self.configureNavigationController()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.detailWaitView.configureDelegation(self)
    }

//    private func setupDelegation() {
//        self.listTableView.delegate = self
//        self.listTableView.dataSource = self
//    }
    
//    private func setupCopyButton() {
//        let action = UIAction { [weak self] _ in
//            if let code = self?.room?.invitation?.code {
//                ToastView.showToast(code: code,
//                                    message: TextLiteral.detailWaitViewControllerCopyCode,
//                                    controller: self ?? UIViewController())
//            }
//        }
//        copyButton.addAction(action, for: .touchUpInside)
//    }
    
    private func presentDetailEditViewController(room: Room, _ isOnlyDateEdit: Bool) {
        guard let index = room.roomInformation?.id,
              let title = room.roomInformation?.title,
              let startDate = room.roomInformation?.startDate,
              let endDate = room.roomInformation?.endDate,
              let currentUserCount = room.participants?.count,
              let capacity = room.roomInformation?.capacity else { return}
        let viewController = DetailEditViewController(editMode: isOnlyDateEdit ? .date : .information,
                                                      roomIndex: index,
                                                      title: title)
        if self.checkStartDateIsPast(startDate) {
            let fiveDaysInterval: TimeInterval = 86400 * 4
            viewController.startDateText = Date().dateToString
            viewController.endDateText = (Date() + fiveDaysInterval).dateToString
        } else {
            viewController.startDateText = startDate
            viewController.endDateText = endDate
        }
        viewController.currentUserCount = currentUserCount
        viewController.sliderValue = capacity
        self.present(viewController, animated: true)
    }
    
    private func checkStartDateIsPast(_ startDate: String) -> Bool {
        guard let startDate = startDate.stringToDate else { return false }
        return startDate.isPast()
    }

//    private func setupNotificationCenter() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.didTapEnterButton), name: .createRoomInvitedCode, object: nil)
//    }
    
//    private func setupTitleViewGesture() {
//        if self.memberType == .owner {
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentEditViewController))
//            self.titleView.addGestureRecognizer(tapGesture)
//        }
//    }
    
    private func presentSelectManittoViewController(nickname: String) {
        let viewController = SelectManittoViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.manitteeName = nickname
        viewController.roomId = self.roomIndex.description
//        viewController.roomId = self.roomInformation?.id?.description
        self.present(viewController, animated: true)
    }
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.detailWaitView.configureNavigationItem(navigationController)
    }

    // MARK: - selector
    
//    @objc
//    private func didTapEnterButton() {
//        guard let roomInfo = self.roomInfo,
//              let code = self.room?.invitation?.code else { return }
//        let viewController = InvitedCodeViewController(roomInfo: RoomDTO(title: roomInfo.title,
//                                                             capacity: roomInfo.capacity,
//                                                             startDate: roomInfo.startDate,
//                                                             endDate: roomInfo.endDate),
//                                                       code: code)
//        viewController.roomInfo = roomInfo
//        viewController.modalPresentationStyle = .overCurrentContext
//        viewController.modalTransitionStyle = .crossDissolve
//        self.present(viewController, animated: true)
//    }
    
//    @objc
//    private func presentEditViewController() {
//        guard let startDate = self.room?.roomInformation?.startDate,
//              let endDate = self.room?.roomInformation?.endDate else { return }
//        self.presentDetailEditViewController(startString: startDate,
//                                             endString: endDate,
//                                             isDateEdit: false)
//    }
    
//    @objc
//    private func changeStartButton() {
//        self.setStartButton()
//    }
    
    // MARK: - network
    
    private func requestWaitRoomInfo() {
        Task {
            do {
                let data = try await self.detailWaitService.getWaitingRoomInfo(roomId: "\(roomIndex)")
                if let roomInfo = data {
                    DispatchQueue.main.async {
                        self.detailWaitView.configureLayout(room: roomInfo)
                    }
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    private func requestStartManitto() {
        Task {
            do {
                let data = try await self.detailWaitService.startManitto(roomId: "\(roomIndex)")
                if let manittee = data {
                    guard let nickname = manittee.nickname else { return }
                    self.presentSelectManittoViewController(nickname: nickname)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
    
    private func requestDeleteRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteRoom(roomId: "\(roomIndex)")
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
    
    private func requestDeleteLeaveRoom() {
        Task {
            do {
                let status = try await self.detailWaitService.deleteLeaveRoom(roomId: "\(roomIndex)")
                if status == 204 {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
}

extension DetailWaitViewController: DetailWaitViewDelegate {
    func startManitto() {
        print("startManitto")
    }
    
    func presentRoomEditViewController(room: Room, _ isOnlyDateEdit: Bool) {
        self.presentDetailEditViewController(room: room, isOnlyDateEdit)
    }
    
    func deleteRoom(title: String, message: String, okTitle: String) {
        self.makeRequestAlert(title: title,
                              message: message,
                              okTitle: okTitle,
                              okAction: { [weak self] _ in
            self?.requestDeleteRoom() { response in
                guard let self else { return }
                switch response {
                case .success:
                    self.navigationController?.popToViewController(self, animated: true)
                case .failure:
                    // FIXME: - 에러 메시지 추가
                    self.makeAlert(title: "에러 메시지 표시하기")
                }
            }
        })
    }
    
    func leaveRoom() {
        print("leaveRoom")
    }
    
    func presentEditViewControllerAfterShowAlert(room: Room) {
        self.makeAlert(title: TextLiteral.detailWaitViewControllerPastAlertTitle,
                       message: TextLiteral.detailWaitViewControllerPastOwnerAlertMessage,
                       okAction: { _ in self.presentDetailEditViewController(room: room, true) }
        )
    }
    
    func showAlert(title: String, message: String) {
        self.makeAlert(title: title, message: message)
    }
}
