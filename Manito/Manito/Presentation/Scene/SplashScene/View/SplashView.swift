//
//  SplashView.swift
//  Manito
//
//  Created by SHIN YOON AH on 10/13/23.
//

import UIKit

import Gifu
import SnapKit

final class SplashView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let logoImageView: UIImageView = UIImageView(image: UIImage.Image.textLogo)
    private let logoGIFImageView: GIFImageView = GIFImageView(image: UIImage(named: GIFSet.logo))

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupGifImage()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - base func
    
    func setupLayout() {
        self.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(30)
            $0.width.equalTo(196)
            $0.height.equalTo(44)
        }
        
        self.addSubview(self.logoGIFImageView)
        self.logoGIFImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.logoImageView.snp.top).offset(-3)
            $0.width.height.equalTo(130)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .backgroundGrey
    }
    
    // MARK: - func
    
    private func setupGifImage() {
        DispatchQueue.main.async {
            self.logoGIFImageView.animate(withGIFNamed: GIFSet.logo)
        }
    }
}
