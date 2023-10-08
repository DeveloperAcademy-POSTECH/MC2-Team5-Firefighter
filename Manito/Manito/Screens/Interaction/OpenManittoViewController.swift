//
//  OpenManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import SnapKit

final class OpenManittoViewController: UIViewController, Navigationable {

    // MARK: - ui component

    private let openManittoView: OpenManittoView = OpenManittoView()

    // MARK: - property

    private let detailRoomRepository: DetailRoomRepository = DetailRoomRepositoryImpl()
    private var friendsList: FriendListDTO = FriendListDTO(count: 0, members: [])
    private let roomId: String
    private let manittoNickname: String
    
    // MARK: - init
    
    init(roomId: String, manittoNickname: String) {
        self.roomId = roomId
        self.manittoNickname = manittoNickname
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func loadView() {
        self.view = self.openManittoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.fetchManittoData()
        self.setupNavigation()
    }

    // MARK: - func

    private func configureDelegation() {
        self.openManittoView.configureDelegation(self)
    }

    private func fetchManittoData() {
        self.fetchFriendList(roomId: self.roomId, manittoNickname: self.manittoNickname) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success((let list, let manittoIndex)):
                self.friendsList = list
                DispatchQueue.main.async {
                    self.openManittoView.setupManittoAnimation(friendList: list,
                                                               manittoIndex: manittoIndex,
                                                               manittoNickname: self.manittoNickname)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.makeAlert(title: TextLiteral.openManittoViewControllerErrorTitle,
                                   message: TextLiteral.openManittoViewControllerErrorDescription)
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    // MARK: - network
    
    private func fetchFriendList(roomId: String,
                                 manittoNickname: String,
                                 completionHandler: @escaping (Result<(FriendListDTO, Int), NetworkError>) -> Void) {
        Task {
            do {
                let data = try await self.detailRoomRepository.fetchWithFriend(roomId: roomId)
                let manittoIndex = data.members?.firstIndex(where: { $0.nickname == manittoNickname }).map { Int($0) } ?? 0
                completionHandler(.success((data, manittoIndex)))
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.encodingError {
                completionHandler(.failure(.encodingError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
}

// MARK: - OpenManittoViewDelegate
extension OpenManittoViewController: OpenManittoViewDelegate {
    func confirmButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension OpenManittoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.friendsList.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OpenManittoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

        if let colorIndex = self.friendsList.members?[indexPath.item].colorIndex {
            cell.configureCell(colorIndex: colorIndex)
        }

        if indexPath.item == self.openManittoView.randomIndex {
            cell.highlightCell()
        }

        return cell
    }
}
