//
//  FriendListViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/19/23.
//

import Combine
import UIKit

final class FriendListViewController: UIViewController, Navigationable {

    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
    private var viewModel: any BaseViewModelType
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
    }

}

// MARK: - UICollectionViewDataSource
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
