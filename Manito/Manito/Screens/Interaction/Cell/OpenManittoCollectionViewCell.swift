//
//  OpenManittoCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/16.
//

import UIKit

import SnapKit

final class OpenManittoCollectionViewCell: UICollectionViewCell, BaseViewType {
    
    // MARK: - ui component
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - base func
    
    func setupLayout() {
        self.contentView.addSubview(self.characterImageView)
        self.characterImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(self.frame.size.width).multipliedBy(0.92)
        }
    }
    
    func configureUI() {
        self.contentView.makeBorderLayer(color: .white)
        self.contentView.layer.cornerRadius = self.frame.size.width / 2
    }
    
    // MARK: - func
    
    func configureCell(colorIndex: Int) {
        self.characterImageView.image = Character.allCases[colorIndex].image
        self.contentView.backgroundColor = Character.allCases[colorIndex].color
        self.contentView.alpha = 0.5
    }
    
    func highlightCell() {
        self.contentView.alpha = 1.0
    }
}
