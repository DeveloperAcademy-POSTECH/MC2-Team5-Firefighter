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
    
    private let imageView = UIImageView(image: ImageLiterals.icNewRoom)
    
    let circleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = .yellow
        circleView.layer.cornerRadius = 44
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.grey003.cgColor
        return circleView
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
        backgroundColor = .darkGrey002.withAlphaComponent(0.8)
        makeBorderLayer(color: UIColor.white.withAlphaComponent(0.5))
    }
    
    func render() {
        addSubview(circleView)
        circleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        
        circleView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(72)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(13)
        }
        
        addSubview(menuLabel)
        menuLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
    }
}
