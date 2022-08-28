//
//  ImageRowView.swift
//  Manito
//
//  Created by 이성호 on 2022/07/02.
//

import UIKit

import SnapKit

class ImageRowView: UIView {
    
    // MARK: - Property
    
    private let imgMaDuna: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgMaDuna
        return imageView
    }()
    private let imgMaHoya: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgMaHoya
        return imageView
    }()
    private let imgNi: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgNi
        return imageView
    }()
    private let imgMaChemi: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgMaChemi
        return imageView
    }()
    private let imgMaLivvy: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgMaLivvy
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

        self.addSubview(imgMaDuna)
        imgMaDuna.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-80)
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(imgMaHoya)
        imgMaHoya.snp.makeConstraints {
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
        
        self.addSubview(imgMaChemi)
        imgMaChemi.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(40)
            $0.height.width.equalTo(40)
        }
        
        self.addSubview(imgMaLivvy)
        imgMaLivvy.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview().offset(80)
            $0.height.width.equalTo(40)
        }
    }
}
