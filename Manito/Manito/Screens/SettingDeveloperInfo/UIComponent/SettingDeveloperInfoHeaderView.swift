//
//  SettingDeveloperInfoHeaderView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/08/13.
//

import UIKit

import SnapKit

final class SettingDeveloperInfoHeaderView: UICollectionReusableView {
    
    // MARK: - property
    
    private let developerRoomView = UIImageView(image: ImageLiterals.imgDevBackground)
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        self.addSubview(developerRoomView)
        developerRoomView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
