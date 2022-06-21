//
//  RoomInfoView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/16.
//

import UIKit

import SnapKit

final class RoomInfoView: UIView {
    
    // MARK: - Property
    
    private let roomLabel: UILabel = {
        let label = UILabel()
        label.text = "명예소방관"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022.06.01 ~ 2022.06.06"
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    
    private let peopleInfo = PeopleInfoView()

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
        
        self.addSubview(roomLabel)
        roomLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(roomLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(peopleInfo)
        peopleInfo.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
