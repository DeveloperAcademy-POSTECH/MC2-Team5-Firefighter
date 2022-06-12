//
//  CommonMissonView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/12.
//

import UIKit
import SnapKit

final class CommonMissonView: UIView {
    
    // MARK: - property
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "오늘의 공통미션"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    
    private lazy var mission: UILabel = {
        let label = UILabel()
        label.text = "별별인사하기"
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
    
    // MARK: - func
    
    private func render() {
        self.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(mission)
        mission.snp.makeConstraints {
            $0.top.equalTo(self.title).offset(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configUI() {
        backgroundColor = .darkGrey001
    }
}
