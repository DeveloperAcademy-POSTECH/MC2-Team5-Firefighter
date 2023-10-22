//
//  ImageRowView.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import UIKit

import SnapKit

final class TopCharacterImageView: UIView {
    
    // MARK: - Property
    
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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func render() {

        self.addSubview(imgCharacterOrange)
        imgCharacterOrange.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-80)
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(imgCharacterPurple)
        imgCharacterPurple.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-40)
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(imgNi)
        imgNi.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(imgCharacterLightGreen)
        imgCharacterLightGreen.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(40)
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(imgCharacterRed)
        imgCharacterRed.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(80)
            $0.height.width.equalTo(40)
        }
    }
}
