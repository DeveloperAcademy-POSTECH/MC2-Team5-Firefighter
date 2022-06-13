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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("아니에요")
    }
}
