//
//  FriendListViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/19/23.
//

import Combine
import UIKit

final class FriendListViewController: UIViewController, Navigationable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
