//
//  SettingButton.swift
//  Manito
//
//  Created by Mingwan Choi on 2022/06/12.
//

import UIKit

final class SettingButton: UIButton {
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.setImage(UIImage.Button.setting, for: .normal)
        self.tintColor = .white
    }
}
