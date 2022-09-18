//
//  LetterCountBadgeView.swift
//  Manito
//
//  Created by 이성호 on 2022/09/19.
//

import UIKit

import SnapKit

class LetterCountBadgeView: UIView {
    
    // MARK: - property
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 20)
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure
    
    private func render() {
        addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configUI() {
        backgroundColor = .mainRed
    }
}
