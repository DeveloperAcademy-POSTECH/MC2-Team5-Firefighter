//
//  ManitoRoomCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/12.
//

import UIKit

import SnapKit

class ManitoRoomCollectionViewCell: UICollectionViewCell{
    static let identifier = "ManitoRoomCollectionViewCell"
    // 삭제필요
    let currentMember = 5
    let goalMember = 10
    
    // MARK: - property
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgNi
        return imageView
    }()
    
    lazy var memberLabel: UILabel = {
        let label = UILabel()
        label.text = "\(currentMember)/\(goalMember)"
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    
    lazy var roomLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.manitoRoomCollectionViewCellRoomLabelTitle
        label.textColor = .white
        label.font = .font(.regular, ofSize: 20)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "22.06.01 ~ 22.06.06"
        label.textColor = .grey001
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    
    private lazy var roomState = RoomStateView()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        render()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    func setupView(){
        backgroundColor = .darkGrey002.withAlphaComponent(0.8)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.cornerRadius = 10
    }
    
    func render() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(14)
            $0.width.height.equalTo(30)
        }
        
        addSubview(memberLabel)
        memberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalTo(imageView.snp.trailing).offset(4)
        }
        
        addSubview(roomLabel)
        roomLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(roomState)
        roomState.snp.makeConstraints {
            $0.top.equalTo(roomLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(14)
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
        }
    }
}
