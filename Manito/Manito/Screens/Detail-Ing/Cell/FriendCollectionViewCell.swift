//
//  FriendCollectionViewCell.swift
//  Manito
//
//  Created by 최성희 on 2022/06/13.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendListBackView: UIView!
    @IBOutlet weak var friendListImageView: UIImageView!
    @IBOutlet weak var friendListNameLabel: UILabel!
    
    func setupFont() {
        friendListNameLabel.font = .font(.regular, ofSize: 15)
    }
    
    func setupViewLayer() {
        friendListBackView.makeBorderLayer(color: .white)
        friendListImageView.layer.cornerRadius = 45
        friendListBackView.layer.cornerRadius = 49
    }
}
