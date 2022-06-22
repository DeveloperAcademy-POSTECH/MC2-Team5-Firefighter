//
//  CreateRoomCollectionCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/13.
//

import UIKit

import SnapKit

class CreateRoomCollectionViewCell: UICollectionViewCell{
    
    // MARK: - property
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private var menuLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 마니또 시작"
        label.textColor = .grey001
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    func setupView(){
        backgroundColor = .grey001.withAlphaComponent(0.3)
        makeBorderLayer(color: UIColor.white.withAlphaComponent(0.5))
    }
    
    func render() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(85)
        }
        
        addSubview(menuLabel)
        menuLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
    }
}
