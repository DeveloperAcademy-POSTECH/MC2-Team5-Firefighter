//
//  ManittoCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import SnapKit

final class ManittoCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        layer.cornerRadius = self.frame.size.width / 2
    }
    
    // MARK: - func
    
    // FIXME: - 현재는 더미데이터
    func setManittoCell(with manittoTypeIndex: Int) {
        backgroundColor = Character.allCases[manittoTypeIndex].color.withAlphaComponent(0.5)
        contentView.alpha = 0.5
        characterImageView.image = Character.allCases[manittoTypeIndex].image
    }
    
    func setHighlightCell(with manittoTypeIndex: Int, matchIndex: Int, imageIndex: Int) {
        if manittoTypeIndex == matchIndex {
            backgroundColor = Character.allCases[imageIndex].color
            contentView.alpha = 1.0
            characterImageView.image = Character.allCases[imageIndex].image
        }
    }
}
