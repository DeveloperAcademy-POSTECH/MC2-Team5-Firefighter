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
    
    deinit {
        print("friend collection view cell is dead")
    }
    
    func setupFont() {
        friendListNameLabel.font = .font(.regular, ofSize: 15)
    }
    
    func setupViewLayer() {
        friendListBackView.makeBorderLayer(color: .white)
        friendListImageView.layer.cornerRadius = 45
        friendListBackView.layer.cornerRadius = 49
    }
    
    func setFriendName(name: String) {
        friendListNameLabel.text = name
    }
    
    func setFriendImage(index: Int) {
        friendListBackView.backgroundColor = Character.allCases[index].color
        friendListImageView.image = Character.allCases[index].image
    }
}
