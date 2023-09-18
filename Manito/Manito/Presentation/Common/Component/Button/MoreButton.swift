//
//  MoreButton.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/10/06.
//

import UIKit

final class MoreButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.setImage(UIImage.Icon.more, for: .normal)
        self.tintColor = .white
    }
}
