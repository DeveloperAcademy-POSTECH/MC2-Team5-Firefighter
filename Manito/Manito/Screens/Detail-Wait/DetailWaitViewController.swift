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

//    private func presentDetailEditViewController(startString: String, endString: String, isDateEdit: Bool) {
//        guard let title = self.titleView.roomTitleLabel.text else { return }
//        let viewController = DetailEditViewController(editMode: isDateEdit ? .date : .information,
//                                                      roomIndex: roomIndex,
//                                                      title: title)
//        viewController.didTappedChangeButton = { [weak self] in
//            self?.requestWaitRoomInfo()
//        }
//        guard let userCount = room?.participants?.count,
//              let capacity = room?.roomInformation?.capacity else { return }
//        viewController.currentUserCount = userCount
//        viewController.sliderValue = capacity
//        viewController.startDateText = startString
//        viewController.endDateText = endString
//        self.present(viewController, animated: true, completion: nil)
//    }

//    private func setupSettingButton() {
//        let rightOffsetSettingButton = super.removeBarButtonItemOffset(with: moreButton,
//                                                                       offsetX: -10)
//        let settingButton = super.makeBarButtonItem(with: rightOffsetSettingButton)
//
//        self.navigationItem.rightBarButtonItem = settingButton
//    }

    private func presentEditRoomView() {
//        guard let roomInformation = self.room?.roomInformation else { return }
//        if roomInformation.isAlreadyPastDate {
//            self.editInfoFromDefaultDate(isDateEdit: false)
//        } else {
//            self.editInfoFromCurrentDate()
//        }
    }
    
    private func editInfoFromDefaultDate(isDateEdit: Bool) {
//        let fiveDaysInterval: TimeInterval = 86400 * 4
//        let defaultStartDate = Date().dateToString
//        let defaultEndDate = (Date() + fiveDaysInterval).dateToString
//        self.presentDetailEditViewController(startString: defaultStartDate,
//                                             endString: defaultEndDate,
//                                             isDateEdit: isDateEdit)
    }
    
    private func editInfoFromCurrentDate() {
//        guard let startDate = self.room?.roomInformation?.startDate,
//              let endDate = self.room?.roomInformation?.endDate else { return }
//        self.presentDetailEditViewController(startString: startDate,
//                                             endString: endDate,
//                                             isDateEdit: false)
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
    
    private func requestDeleteRoom() {
        Task {
            do {
                let status = try await self.detailWaitService.deleteRoom(roomId: "\(roomIndex)")
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
    
    func presentRoomEditViewController() {
        print("presentRoomEditViewController")
    }
    
    func deleteRoom() {
        print("deleteRoom")
    }
    
    func leaveRoom() {
        print("leaveRoom")
    }
    
    func showAlert(title: String, message: String) {
        self.makeAlert(title: title, message: message)
    }
}
