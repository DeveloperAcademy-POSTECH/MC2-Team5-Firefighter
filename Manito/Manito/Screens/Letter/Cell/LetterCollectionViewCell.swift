//
//  LetterCollectionViewCell.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

final class LetterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - property
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
