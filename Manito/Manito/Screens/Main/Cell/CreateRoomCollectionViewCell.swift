//
//  CreateRoomCollectionCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/13.
//

import UIKit

import SnapKit

final class CreateRoomCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    private let imageView = UIImageView(image: ImageLiterals.icNewRoom)    
    private let circleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = .yellow
        circleView.layer.cornerRadius = 44
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.grey003.cgColor
        return circleView
    }()
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.createRoomCollectionViewCellMenuLabel
        label.textColor = .grey001
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    
    // MARK: - life cycle
    
    override func setupLayout() {
        self.addSubview(self.circleView)
        self.circleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        
        self.circleView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.width.height.equalTo(72)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(13)
        }
        
        self.addSubview(self.menuLabel)
        self.menuLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configureUI(){
        self.backgroundColor = .darkGrey002.withAlphaComponent(0.8)
        self.makeBorderLayer(color: UIColor.white.withAlphaComponent(0.5))
    }
}
