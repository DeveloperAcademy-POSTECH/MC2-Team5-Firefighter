//
//  OpenManittoViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import SnapKit

final class OpenManittoViewController: BaseViewController {

    // MARK: - ui component

    private let openManittoView: OpenManittoView = OpenManittoView()

    // MARK: - property

    private let openManittoService: DetailIngAPI = DetailIngAPI(apiService: APIService())
    private var friendsList: FriendList = FriendList(count: 0, members: [])
    private let roomId: String
    private let manittoNickname: String
    
    // MARK: - init
    
    init(roomId: String, manittoNickname: String) {
        super.init()
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
        self.fetchManittoData()
    }

    // MARK: - func

    private func fetchManittoData() {
        self.fetchFriendList(roomId: self.roomId, manittoNickname: self.manittoNickname) { [weak self] response in
            switch response {
            case .success((let list, let manittoIndex)):
                self?.friendsList = list
                DispatchQueue.main.async {
                    self?.openManittoView.animateManittoCollectionView(with: list, manittoIndex)
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.makeAlert(title: TextLiteral.openManittoViewControllerErrorTitle,
                                    message: TextLiteral.openManittoViewControllerErrorDescription)
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    // MARK: - network
    
    private func fetchFriendList(roomId: String,
                                 manittoNickname: String,
                                 completionHandler: @escaping (Result<(FriendList, Int), NetworkError>) -> Void) {
        Task {
            do {
                let data = try await self.openManittoService.requestWithFriends(roomId: roomId)
                if let list = data {
                    let manittoIndex = list.members?.firstIndex(where: { $0.nickname == manittoNickname }).map { Int($0) } ?? 0
                    completionHandler(.success((list, manittoIndex)))
                }
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

// MARK: - UICollectionViewDataSource
extension OpenManittoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.friendsList.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ManittoCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

        if let colorIdx = self.friendsList.members?[indexPath.item].colorIdx {
            cell.setManittoCell(with: colorIdx)
            cell.setHighlightCell(with: indexPath.item, matchIndex: self.manittoRandomIndex, imageIndex: colorIdx)
        }

        return cell
    }
}
