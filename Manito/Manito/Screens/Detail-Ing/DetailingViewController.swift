//
//  DetailngCodebaseViewController.swift
//  Manito
//
//  Created by creohwan on 2022/11/03.
//

import UIKit

import SnapKit

final class DetailingViewController: BaseViewController {
    
    // MARK: - property
    
    private let detailIngService: DetailIngAPI = DetailIngAPI(apiService: APIService())
    private let detailDoneService: DetailDoneAPI = DetailDoneAPI(apiService: APIService())
    private let roomId: String
    private var missionId: String = ""
    
    // MARK: - component
    
    private let detailingView: DetailingView = DetailingView()
    
    // MARK: - init
    
    init(roomId: String) {
        self.roomId = roomId
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
        self.view = self.detailingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.configureNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupLargeTitleToOriginal()
        self.requestRoomInformation()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.detailingView.configureDelegation(self)
    }
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        self.detailingView.configureNavigationItem(navigationController)
    }
    
    private func setupLargeTitleToOriginal() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
        
    private func openManittee(manitteeName: String) {
        let viewController = SelectManitteeViewController(roomId: self.roomId, manitteeNickname: manitteeName)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    private func pushFriendListViewController() {
        let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: FriendListViewController.className) as? FriendListViewController else { return }
        guard let roomId = Int(roomId) else { return }
        viewController.roomIndex = roomId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentEditMissionView(mission: String, roomId: String) {
        let viewController = MissionEditViewController(mission: mission, roomId: roomId)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.setDelegate(self)
        self.present(viewController, animated: true)
    }
    
    private func resetMission() {
        self.makeRequestAlert(title: TextLiteral.detailIngViewControllerResetMissionAlertTitle,
                              message: TextLiteral.detailIngViewControllerResetMissionAlertMessage,
                              okTitle: TextLiteral.detailIngViewControllerResetMissionAlertOkTitle,
                              okStyle: .default,
                              okAction: { _ in
            // FIXME: - API 연결
        })
    }
    
    private func requestRoomInformation() {
        self.fetchRoomInformation() { [weak self] result in
            switch result {
            case .success(let roomInformation):
                self?.detailingView.updateDetailingView(room: roomInformation)
            case .failure:
                print("error")
            }
        }
    }
    
    // MARK: - network
   
    private func fetchRoomInformation(completionHandler: @escaping ((Result<Room, NetworkError>) -> Void)) {
        Task {
            do {
                let data = try await detailIngService.requestStartingRoomInfo(roomId: roomId)
                if let info = data {
                    completionHandler(.success(info))
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
    
    func pushNavigationAfterRequestRoomInfo() {
        Task {
            do {
                let data = try await detailIngService.requestStartingRoomInfo(roomId: self.roomId)
                if let info = data {
                    guard let state = info.roomInformation?.state,
                          let mission = info.mission?.content,
                          let missionId = info.mission?.id
                    else { return }
                    let viewController = LetterViewController(roomState: state,
                                                              roomId: self.roomId,
                                                              mission: mission,
                                                              missionId: missionId.description,
                                                              entryPoint: .notification)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    private func requestExitRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await detailDoneService.requestExitRoom(roomId: roomId)
                switch statusCode {
                case 200..<300: completionHandler(.success(()))
                default: completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
                makeAlert(title: TextLiteral.detailIngViewControllerDoneExitAlertAdmin)
            }
        }
    }
    
    private func requestDeleteRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await detailDoneService.requestDeleteRoom(roomId: roomId)
                switch statusCode {
                case 200..<300: completionHandler(.success(()))
                default: completionHandler(.failure(.unknownError))
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

extension DetailingViewController: DetailingDelegate {
    func editMissionButtonDidTap(mission: String) {
        typealias AlertAction = ((UIAlertAction) -> ())
        let editMissionAction: AlertAction = { [weak self] _ in
            guard let roomId = self?.roomId else { return }
            self?.presentEditMissionView(mission: mission, roomId: roomId)
        }
        let resetAction: AlertAction = { [weak self] _ in
            self?.resetMission()
        }
        
        self.makeActionSheet(title: TextLiteral.detailIngViewControllerMissionEditTitle,
                             actionTitles: [
                                TextLiteral.detailIngViewControllerSelfEditMissionTitle,
                                TextLiteral.detailIngViewControllerResetMissionTitle,
                                TextLiteral.cancel],
                             actionStyle: [.default, .default, .cancel],
                             actions: [editMissionAction, resetAction, nil])
    }
    
    func listBackDidTap() {
        self.pushFriendListViewController()
    }
    
    func letterBoxDidTap(type: String,
                         mission: String,
                         missionId: String) {
          let letterViewController = LetterViewController(roomState: type,
                                                          roomId: self.roomId,
                                                          mission: mission,
                                                          missionId: missionId,
                                                          entryPoint: .detail)
          self.navigationController?.pushViewController(letterViewController, animated: true)
    }
    
    func manittoMemoryButtonDidTap() {
        let viewController = MemoryViewController(roomId: self.roomId)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func manittoOpenButtonDidTap(nickname: String) {
        let viewController = OpenManittoViewController(roomId: self.roomId, manittoNickname: nickname)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    func deleteButtonDidTap() {
        self.requestDeleteRoom() { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure:
                print("error")
            }
        }
    }
    
    func leaveButtonDidTap() {
        self.requestExitRoom() { [weak self] result in
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure:
                print("error")
            }
        }
    }
    
    func didNotShowManitteeView(manitteeName: String) {
        self.openManittee(manitteeName: manitteeName)
    }
}

extension DetailingViewController: MissionEditDelegate {
    func didChangeMission(mission: String) {
        self.detailingView.updateMission(mission: mission)
    }
}
