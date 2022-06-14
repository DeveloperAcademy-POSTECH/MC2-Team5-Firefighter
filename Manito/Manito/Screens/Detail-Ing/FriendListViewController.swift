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
        friendListCollectionView.delegate = self
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
