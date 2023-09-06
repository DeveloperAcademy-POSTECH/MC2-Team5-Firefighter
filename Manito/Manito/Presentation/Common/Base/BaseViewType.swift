//
//  BaseViewType.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/05.
//

import UIKit

protocol BaseViewType: UIView {
    func setupLayout()
    func configureUI()
}

extension BaseViewType {
    func baseInit() {
        self.setupLayout()
        self.configureUI()
    }
}
