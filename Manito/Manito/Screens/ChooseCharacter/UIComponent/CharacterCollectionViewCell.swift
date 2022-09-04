//
//  CharacterCollectionViewCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/09/04.
//

import UIKit

import SnapKit

final class CharacterCollectionViewCell: BaseCollectionViewCell {
    
    var characterBackground: UIColor?
    
    // MARK: - property
    
    lazy var characterImageView: UIImageView = {
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
//        backgroundColor = characterBackground?.withAlphaComponent(0.5)
        layer.cornerRadius = self.frame.size.width / 2
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? characterBackground : characterBackground?.withAlphaComponent(0.5)
            contentView.alpha = isSelected ? 1.0 : 0.5
        }
    }
    
    func setImageBackgroundColor() {
        backgroundColor = characterBackground?.withAlphaComponent(0.5)
        contentView.alpha = 0.5
    }
}
