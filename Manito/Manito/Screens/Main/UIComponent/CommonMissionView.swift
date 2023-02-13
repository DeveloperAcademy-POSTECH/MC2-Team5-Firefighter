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
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    private func setupLayout() {
        self.addSubview(self.commonMissionImageView)
        self.commonMissionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(self.title)
        self.title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(self.mission)
        self.mission.snp.makeConstraints {
            $0.top.equalTo(self.title.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
