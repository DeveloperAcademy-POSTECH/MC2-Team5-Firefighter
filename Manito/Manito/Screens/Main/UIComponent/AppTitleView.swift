//
//  AppTitleView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/13.
//

import UIKit

import SnapKit

final class AppTitleView: UIView {
    
    // MARK: - property
    
    private let appLogo: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
    }()
    
    private let appName: UILabel = {
        let label = UILabel()
        label.text = "MANITO"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 28)
        return label
    }()

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
        self.addSubview(appLogo)
        appLogo.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        self.addSubview(appName)
        appName.snp.makeConstraints {
            $0.leading.equalTo(self.appLogo.snp.trailing).offset(5)
        }
    }
}
