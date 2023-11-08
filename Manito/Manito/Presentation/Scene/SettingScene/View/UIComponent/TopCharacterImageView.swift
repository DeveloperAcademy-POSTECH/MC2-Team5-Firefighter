//
//  ImageRowView.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import UIKit

import SnapKit

final class TopCharacterImageView: UIView {
    
    // MARK: - ui component
    
    private let imgCharacterOrange: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Image.characterOrange
        return imageView
    }()
    private let imgCharacterPurple: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Image.characterPurple
        return imageView
    }()
    private let imgNi: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Image.ni
        return imageView
    }()
    private let imgCharacterLightGreen: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Image.characterLightGreen
        return imageView
    }()
    private let imgCharacterRed: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Image.characterRed
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.imgCharacterOrange)
        self.imgCharacterOrange.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-80)
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(self.imgCharacterPurple)
        self.imgCharacterPurple.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-40)
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(self.imgNi)
        self.imgNi.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(self.imgCharacterLightGreen)
        self.imgCharacterLightGreen.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(40)
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(self.imgCharacterRed)
        self.imgCharacterRed.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(80)
            $0.height.width.equalTo(40)
        }
    }
}
