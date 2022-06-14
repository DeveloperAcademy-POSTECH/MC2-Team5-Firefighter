//
//  FriendListViewController.swift
//  Manito
//
//  Created by 최성희 on 2022/06/13.
//

import UIKit

class FriendListViewController: UIViewController {
    
    @IBOutlet weak var friendListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendListCollectionView.dataSource = self
    }
}

extension FriendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendCollectionViewCell.className, for: indexPath) as? FriendCollectionViewCell else { return UICollectionViewCell() }
        cell.setupFont()
        cell.setupViewLayer()
        cell.makeBorderLayer(color: .white)
        return cell
    }
}
