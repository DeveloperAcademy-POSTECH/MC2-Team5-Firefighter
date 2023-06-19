//
//  DetailngCodebaseViewController.swift
//  Manito
//
//  Created by creohwan on 2022/11/03.
//

import UIKit

import SnapKit

final class DetailingViewController: BaseViewController {
    
    private let detailIngService: DetailIngAPI = DetailIngAPI(apiService: APIService())
    private let detailDoneService: DetailDoneAPI = DetailDoneAPI(apiService: APIService())
    private let roomId: String
    private var missionId: String = ""

    // MARK: - property
    
    private let detailingView: DetailingView = DetailingView()
    
    // MARK: - init
    
    init(roomId: String) {
        self.roomId = roomId
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
        self.view = self.detailingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.configureNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLargeTitleToOriginal()
        self.requestRoomInfo() { [weak self] result in
            switch result {
            case .success(let roomInformation):
                self?.detailingView.updateDetailingView(room: roomInformation)
            case .failure:
                print("error")
            }
        }
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
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
        
    private func openManittee(manitteeName: String) {
        let viewController = SelectManitteeViewController(roomId: self.roomId, manitteeNickname: manitteeName)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
        
    func pushNavigationAfterRequestRoomInfo() {
        Task {
            do {
                let data = try await detailIngService.requestStartingRoomInfo(roomId: roomId)
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
      
    // FIXME: - 추후 PR 때, friendslistViewController codebase로 만들 예정
    @objc
    private func pushFriendListViewController(_ gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "DetailIng", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: FriendListViewController.className) as? FriendListViewController else { return }
        guard let roomId = Int(roomId) else { return }
        viewController.roomIndex = roomId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - DetailStarting API
   
    private func requestRoomInfo(completionHandler: @escaping ((Result<Room, NetworkError>) -> Void)) {
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
    
    private func requestExitRoom() {
        Task {
            do {
                let statusCode = try await detailDoneService.requestExitRoom(roomId: roomId)
                if statusCode == 204 {
                    navigationController?.popViewController(animated: true)
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
    
    private func requestDeleteRoom() {
        Task {
            do {
                let statusCode = try await detailDoneService.requestDeleteRoom(roomId: roomId)
                if statusCode == 204 {
                    navigationController?.popViewController(animated: true)
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
    
    func listBackDidTap() {
        print("")
    }
    
    func letterBoxDidTap() {
        print("")
    }
    
    func manittoMemoryButtonDidTap() {
        print("")
    }
    
    func manittoOpenButtonDidTap() {
        print("")
    }
    
    func deleteButtonDidTap() {
        print("")
    }
    
    func leaveButtonDidTap() {
        print("")
    }
    
    func didNotShowManitteeView(manitteeName: String) {
        self.openManittee(manitteeName: manitteeName)
    }
}
