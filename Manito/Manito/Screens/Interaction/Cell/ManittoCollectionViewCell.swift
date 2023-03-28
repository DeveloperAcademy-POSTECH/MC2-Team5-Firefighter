//
//  ManittoCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import SnapKit

final class ManittoCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - ui component
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - override
    
    override func setupLayout() {
        self.contentView.addSubview(self.characterImageView)
        self.characterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(self.frame.size.width).multipliedBy(0.92)
        }
    }
    
    override func configureUI() {
        self.makeBorderLayer(color: .white)
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    // MARK: - func
    
    func configureCell(colorIndex: Int) {
        self.backgroundColor = Character.allCases[colorIndex].color.withAlphaComponent(0.5)
        self.characterImageView.image = Character.allCases[colorIndex].image
        self.contentView.alpha = 0.5
    }
    
    func highlightCell() {
        self.contentView.alpha = 1.0
    }
}
