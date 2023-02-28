//
//  IndividualMissionView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class IndividualMissionView: UIView {
    
    // MARK: - ui component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.individualMissionViewTitleLabel
        label.font = .font(.regular, ofSize: 14)
        label.textColor = .grey002
        return label
    }()
    private let missionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .font(.regular, ofSize: 20)
        label.textAlignment = .center
        label.contentMode = .center
        return label
    }()
    
    // MARK: - init
    
    init(mission: String) {
        super.init(frame: .zero)
        self.setupMission(with: mission)
        self.setupLayout()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(15)
        }
        
        self.addSubview(self.missionLabel)
        self.missionLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(21)
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .darkGrey004
        self.makeBorderLayer(color: .subOrange)
    }

    private func setupMission(with mission: String) {
        self.missionLabel.text = mission
    }
}
