//
//  RoomStateView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/13.
//

import UIKit

import SnapKit

final class RoomStateView: UIView {
    
    let roomState = "진행중"
    
    // MARK: - property
    
    private lazy var state: UILabel = {
        let label = UILabel()
        label.text = roomState
        label.textColor = .white
        label.font = .font(.regular, ofSize: 12)
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
    
    // MARK: - func
    
    private func render() {
        self.addSubview(state)
        state.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configUI() {
        backgroundColor = .red
        layer.cornerRadius = 12
    }
}
