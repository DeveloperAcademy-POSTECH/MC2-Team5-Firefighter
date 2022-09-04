//
//  CharacterCollectionViewCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/09/04.
//

import UIKit

import SnapKit

final class CharacterCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageLiterals.imgMa
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        contentView.addSubview(characterImageView)
        characterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(self.frame.size.width).multipliedBy(0.92)
        }
    }
    
    override func configUI() {
        makeBorderLayer(color: .white)
        backgroundColor = .characterYellow
        layer.cornerRadius = self.frame.size.width / 2
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
                contentView.alpha = 0.5
            } else {
                backgroundColor = backgroundColor?.withAlphaComponent(1.0)
                contentView.alpha = 1.0
            }
        }
    }
}
