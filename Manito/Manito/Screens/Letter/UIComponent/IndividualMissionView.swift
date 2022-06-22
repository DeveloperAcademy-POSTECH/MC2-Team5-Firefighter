//
//  IndividualMissionView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class IndividualMissionView: UIView {
    
    // MARK: - property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 개별 미션"
        label.font = .font(.regular, ofSize: 14)
        label.textColor = .grey002
        return label
    }()
    private lazy var missionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = missionText
        label.font = .font(.regular, ofSize: 20)
        label.textAlignment = .center
        label.contentMode = .center
        return label
    }()
    
    private var missionText: String

    // MARK: - init
    
    init(mission: String) {
        missionText = mission
        super.init(frame: .zero)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(missionLabel)
        missionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(21)
        }
    }
    
    private func configUI() {
        backgroundColor = .darkGrey003
        makeBorderLayer(color: .subOrange)
    }
}
