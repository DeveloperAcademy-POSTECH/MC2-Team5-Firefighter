//
//  OpenManittoPopupViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

import SnapKit

final class OpenManittoPopupViewController: BaseViewController {

    // MARK: - property
    
    private let popupView = UIImageView(image: ImageLiterals.imgEnterRoom)
    
    // MARK: - life cycle
    
    override func render() {
        view.addSubview(popupView)
        popupView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(UIScreen.main.bounds.size.height * 0.15)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(popupView.snp.width).multipliedBy(1.16)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
    }
}
