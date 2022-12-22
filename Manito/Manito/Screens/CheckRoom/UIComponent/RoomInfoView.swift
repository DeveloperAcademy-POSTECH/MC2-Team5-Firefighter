//
//  RoomInfoView.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/16.
//

import UIKit

import SnapKit

final class RoomInfoView: UIView {
    
    // MARK: - property
    
    let roomLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        return label
    }()    
    let peopleInfoView = PeopleInfoView()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
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
        
        self.addSubview(peopleInfoView)
        peopleInfoView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}
