//
//  RoomStateView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/13.
//

import UIKit

import SnapKit

final class RoomStateView: UIView {
    
    // MARK: - ui component
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 12)
        return label
    }()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.stateLabel)
        self.stateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 12
    }
}
