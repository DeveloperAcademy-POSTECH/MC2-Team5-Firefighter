//
//  CommonMissionView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/12.
//

import UIKit

import SnapKit

final class CommonMissionView: UIView {
    
    // MARK: - property
    
    private let commonMissionImageView = UIImageView(image: ImageLiterals.imgCommonMisson)
    private let title: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.commonMissionViewTitle
        label.textColor = .grey001
        label.font = .font(.regular, ofSize: 15)
        return label
    }()    
    let mission: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.font = .font(.regular, ofSize: 25)
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
    
    // MARK: - life cycle
    
    private func render() {
        self.addSubview(commonMissionImageView)
        commonMissionImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(commonMissionImageView.snp.width).multipliedBy(0.61)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        self.addSubview(mission)
        mission.snp.makeConstraints {
            $0.top.equalTo(self.title.snp.bottom).offset(23)
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
    
    private func configUI() {
        self.isSkeletonable = true
    }
}
