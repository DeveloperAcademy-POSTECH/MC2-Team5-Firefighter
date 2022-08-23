//
//  DeveloperInfoViewCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/07/10.
//

import UIKit

import SnapKit

class DeveloperInfoViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    let developerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgNi
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 24)
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 15)
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    override func configUI() {
        backgroundColor = .grey001.withAlphaComponent(0.1)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        layer.cornerRadius = 10
    }
    
    override func render() {
        addSubview(developerImageView)
        developerImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.width.height.equalTo(80)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(developerImageView.snp.trailing).offset(20)
        }
        
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalTo(developerImageView.snp.trailing).offset(20)
        }
    }
}
