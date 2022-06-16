//
//  BackButton.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

final class BackButton: UIButton {

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func configUI() {
        self.setImage(ImageLiterals.btnBack, for: .normal)
        self.tintColor = .white
    }
}
