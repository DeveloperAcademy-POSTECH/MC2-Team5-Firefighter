//
//  CharacterCollectionViewCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/09/04.
//

import UIKit

import SnapKit

final class CharacterCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - ui component
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageLiterals.imgMa
        return imageView
    }()
    
    // MARK: - property
    
    private var characterBackgroundColor: UIColor?
    
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
        layer.cornerRadius = self.frame.size.width / 2
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = self.isSelected ? self.characterBackgroundColor : self.characterBackgroundColor?.withAlphaComponent(0.5)
            self.contentView.alpha = self.isSelected ? 1.0 : 0.5
        }
    }

    func configureBackgroundColor(color: UIColor) {
        self.characterBackgroundColor = color
        self.backgroundColor = self.characterBackgroundColor?.withAlphaComponent(0.5)
        self.contentView.alpha = 0.5
    }
    
    func configureImage(image: UIImage) {
        self.characterImageView.image = image
    }
}
