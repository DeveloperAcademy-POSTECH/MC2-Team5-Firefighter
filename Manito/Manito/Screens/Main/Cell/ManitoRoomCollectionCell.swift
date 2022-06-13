//
//  ManitoRoomCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/12.
//

import SnapKit
import UIKit

class ManitoRoomCollectionViewCell: UICollectionViewCell{
    static let identifier = "ManitoRoomCollectionViewCell"
    
    let currentMember = 5
    let goalMember = 10
    
    // MARK: - property
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy var member: UILabel = {
        let label = UILabel()
        label.text = "\(currentMember)/\(goalMember)"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    
    lazy var room: UILabel = {
        let label = UILabel()
        label.text = "마니또"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 20)
        return label
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.text = "22.06.01 ~ 22.06.06"
        label.textColor = .grey003
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    
    private lazy var roomState: RoomStateView = {
        let roomState = RoomStateView()
        return roomState
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    func setupView(){
        backgroundColor = .grey003.withAlphaComponent(0.3)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.cornerRadius = 10

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(14)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        addSubview(member)
        member.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalTo(imageView.snp.trailing).offset(4)
        }
        
        addSubview(room)
        room.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(roomState)
        roomState.snp.makeConstraints {
            $0.top.equalTo(room.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(14)
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }
        
        addSubview(date)
        date.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
        }
    }
}
