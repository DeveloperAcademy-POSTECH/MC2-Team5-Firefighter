//
//  LetterCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

final class LetterCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - property
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configUI() {
        backgroundColor = .mainRed
        makeBorderLayer(color: .white.withAlphaComponent(0.5))
    }
}
