//
//  ManitoRoomCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/12.
//

import SnapKit
import UIKit

class ManitoRoomCollectionViewCell: UICollectionViewCell{
    static let identifier = "ManitoRoomCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    func setupView(){
        backgroundColor = .blue

        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
