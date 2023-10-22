//
//  DetailngCodebaseViewController.swift
//  Manito
//
//  Created by creohwan on 2022/11/03.
//

import UIKit

import SnapKit

final class DetailingViewController: UIViewController, Navigationable {
    
    // MARK: - property
    
    private let detailRoomRepository: DetailRoomRepository = DetailRoomRepositoryImpl()
    private let roomId: String
    private var missionId: String = ""
    
    // MARK: - component
    
    private let detailingView: DetailingView = DetailingView()
    
    // MARK: - init
    
    init(roomId: String) {
        self.roomId = roomId
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
        self.view = self.detailingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.configureNavigationController()
        self.setupNavigation()
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
        self.makeRequestAlert(title: TextLiteral.DetailIng.resetAlertTitle.localized(),
                              message: TextLiteral.DetailIng.resetAlertMessage.localized(),
                              okTitle: TextLiteral.DetailIng.resetAlertOk.localized(),
                              okStyle: .default,
                              okAction: { [weak self] _ in
            guard let roomId = self?.roomId else { return }
            self?.requestResetMission(roomId: roomId) { result in
                switch result {
                case .success():
                    self?.requestRoomInformation()
                case .failure:
                    self?.makeAlert(title: TextLiteral.Common.Error.title.localized(),
                                    message: TextLiteral.DetailIng.Error.resetMessage.localized())
                }
            }
        })
    }
    
    private func requestRoomInformation() {
        self.fetchRoomInformation() { [weak self] result in
            switch result {
            case .success(let roomInformation):
                self?.detailingView.updateDetailingView(room: roomInformation.toRoomInfo())
            case .failure:
                print("error")
            }
        }
    }
    
    // MARK: - network
   
    private func fetchRoomInformation(completionHandler: @escaping ((Result<RoomInfoDTO, NetworkError>) -> Void)) {
        Task {
            do {
                let data = try await detailRoomRepository.fetchRoomInfo(roomId: roomId)
                completionHandler(.success(data))
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
                let data = try await self.detailRoomRepository.fetchRoomInfo(roomId: self.roomId)
                guard let mission = data.mission?.content,
                      let missionId = data.mission?.id
                else { return }
                // FIXME: - RoomType를 View에서 바로 빼오지 않고 다른 방식으로 구현해야 합니다.
                let usecase = LetterUsecaseImpl(repository: LetterRepositoryImpl())
                let viewModel = LetterViewModel(usecase: usecase,
                                                roomId: self.roomId,
                                                mission: mission,
                                                missionId: missionId.description,
                                                roomStatus: self.detailingView.roomType,
                                                messageType: .received)
                let letterViewController = LetterViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(letterViewController, animated: true)
            }
        }
    }
    
    private func requestExitRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await self.detailRoomRepository.deleteLeaveRoom(roomId: roomId)
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
                // FIXME: - Exit, Delete가 각각 누구에게 쓰이는지가 불분명하고 에러 처리가 잘 되어 있지 않아서 작성하지 않았습니다.
                // 담당하시는 분께 맡기겠습니다.🙇‍♂️
            }
        }
    }
    
    private func requestDeleteRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await self.detailRoomRepository.deleteRoom(roomId: roomId)
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
                // FIXME: - Exit, Delete가 각각 누구에게 쓰이는지가 불분명하고 에러 처리가 잘 되어 있지 않아서 작성하지 않았습니다.
                // 담당하시는 분께 맡기겠습니다.🙇‍♂️
            }
        }
    }
    
    private func requestResetMission(roomId: String, completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let data = try await self.detailRoomRepository.fetchResetMission(roomId: roomId)
                completionHandler(.success(()))
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
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
        
        self.makeActionSheet(title: TextLiteral.DetailIng.missionMenuTitle.localized(),
                             actionTitles: [
                                TextLiteral.DetailIng.missionMenuSetting.localized(),
                                TextLiteral.DetailIng.missionMenuReset.localized(),
                                TextLiteral.Common.cancel.localized()],
                             actionStyle: [.default, .default, .cancel],
                             actions: [editMissionAction, resetAction, nil])
    }
    
    func listBackDidTap() {
        self.pushFriendListViewController()
    }
    
    func letterBoxDidTap(type: String,
                         mission: String,
                         missionId: String) {
        // FIXME: - RoomType를 View에서 바로 빼오지 않고 다른 방식으로 구현해야 합니다.
        let usecase = LetterUsecaseImpl(repository: LetterRepositoryImpl())
        let viewModel = LetterViewModel(usecase: usecase,
                                        roomId: self.roomId,
                                        mission: mission,
                                        missionId: missionId.description,
                                        roomStatus: self.detailingView.roomType,
                                        messageType: .sent)
        let letterViewController = LetterViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(letterViewController, animated: true)
    }
    
    func manittoMemoryButtonDidTap() {
        let usecase = MemoryUsecaseImpl(repository: DetailRoomRepositoryImpl())
        let viewModel = MemoryViewModel(usecase: usecase, roomId: self.roomId)
        let viewController = MemoryViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func manittoOpenButtonDidTap(nickname: String) {
        let usecase = OpenManittoUsecaseImpl(repository: DetailRoomRepositoryImpl())
        let viewModel = OpenManittoViewModel(usecase: usecase,
                                             roomId: self.roomId,
                                             manittoNickname: nickname)
        let viewController = OpenManittoViewController(viewModel: viewModel)
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
    func didChangeMission() {
        self.requestRoomInformation()
    }
}
