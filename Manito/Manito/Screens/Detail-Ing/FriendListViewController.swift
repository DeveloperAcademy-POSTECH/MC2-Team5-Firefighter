//
//  FriendListViewController.swift
//  Manito
//
//  Created by 최성희 on 2022/06/13.
//

import UIKit

final class FriendListViewController: BaseViewController, BaseViewControllerType {
    var friendArray: [MemberInfoDTO] = [] {
        didSet {
            friendListCollectionView.reloadData()
        }
    }
    var detailRoomRepository: DetailRoomRepository = DetailRoomRepositoryImpl()
    
    var roomIndex: Int = 0
    
    @IBOutlet weak var friendListCollectionView: UICollectionView!
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        requestWithFriends()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()
        setupDelegation()
    }

    // MARK: - base func

    func setupLayout() {
        // FIXME: - 스토리보드를 코드 베이스로 바꿔야 하는 화면입니다.
    }

    func configureUI() {
        self.view.backgroundColor = .backgroundGrey
        self.friendListCollectionView.backgroundColor = .clear
    }

    // MARK: - func
    
    private func setupDelegation() {
        friendListCollectionView.delegate = self
        friendListCollectionView.dataSource = self
    }
    
    // MARK: - API
    
    private func requestWithFriends() {
        Task {
            do {
                let data = try await self.detailRoomRepository.fetchWithFriend(roomId: "\(roomIndex)")
                friendArray = data.members ?? []
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

extension FriendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.className, for: indexPath) as? FriendCollectionViewCell else { return UICollectionViewCell() }
        cell.setupFont()
        cell.setupViewLayer()
        cell.makeBorderLayer(color: .white)
        cell.setFriendName(name: friendArray[indexPath.item].nickname ?? "닉네임")
        cell.setFriendImage(index: friendArray[indexPath.item].colorIndex ?? 0)
        return cell
    }
}

extension FriendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.size.width - (28 * 2 + 14)) / 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 18, left: 28, bottom: 18, right: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}
