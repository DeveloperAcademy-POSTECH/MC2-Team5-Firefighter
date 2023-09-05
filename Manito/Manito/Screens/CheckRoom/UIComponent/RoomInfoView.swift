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
    
    private let roomLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        return label
    }()    
    private let peopleInfoView = PeopleInfoView()

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
        self.addSubview(self.roomLabel)
        self.roomLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.roomLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        self.addSubview(self.peopleInfoView)
        self.peopleInfoView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.centerX.bottom.equalToSuperview()
        }
    }
    
    func setupRoomInfo(roomInfo: ParticipateRoomInfo) {
        let title = roomInfo.title
        let capacity = roomInfo.capacity
        let startDate = roomInfo.startDate
        let endDate = roomInfo.endDate
        
        self.roomLabel.text = title
        self.dateLabel.text = "\(startDate) ~ \(endDate)"
        self.peopleInfoView.peopleLabel.text = "X \(capacity)인"
    }
}
