//
//  CreateRoomCollectionCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/13.
//

import SnapKit
import UIKit

class CreateRoomCollectionViewCell: UICollectionViewCell{
    static let identifier = "CreateRoomCollectionViewCell"
    
    // MARK: - property
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private var menu: UILabel = {
        let label = UILabel()
        label.text = "새로운 마니또 시작"
        label.textColor = .grey003
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    func setupView(){
        backgroundColor = .grey003.withAlphaComponent(0.3)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.cornerRadius = 10

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(85)
            $0.height.equalTo(85)
        }
        
        addSubview(menu)
        menu.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
    }
}
