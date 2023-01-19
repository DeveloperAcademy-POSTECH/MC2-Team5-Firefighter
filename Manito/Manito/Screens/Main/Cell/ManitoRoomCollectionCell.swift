//
//  ManitoRoomCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/12.
//

import UIKit

import SnapKit

final class ManitoRoomCollectionViewCell: BaseCollectionViewCell {

    private enum RoomStatus: String {
        case PRE = "대기중"
        case PROCESSING = "진행중"
        case POST = "완료"
    }
    
    // MARK: - property
    
    private let imageView = UIImageView(image: ImageLiterals.imgNi)
    let memberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    let roomLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.manitoRoomCollectionViewCellRoomLabelTitle
        label.textColor = .white
        label.font = .font(.regular, ofSize: 20)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey001
        label.font = .font(.regular, ofSize: 14)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()    
    lazy var roomStateView = RoomStateView()
    
    // MARK: - life cycle
    
    override func render() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(9)
            $0.width.height.equalTo(30)
        }
        
        contentView.addSubview(memberLabel)
        memberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalTo(imageView.snp.trailing).offset(4)
        }
        
        contentView.addSubview(roomLabel)
        roomLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(17)
        }
        
        contentView.addSubview(roomStateView)
        roomStateView.snp.makeConstraints {
            $0.top.equalTo(roomLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(12)
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configUI() {
        backgroundColor = .darkGrey002.withAlphaComponent(0.8)
        makeBorderLayer(color: UIColor.white.withAlphaComponent(0.5))
        
        self.isSkeletonable = true
        imageView.isSkeletonable = true
        roomLabel.isSkeletonable = true
        roomStateView.isSkeletonable = true
        
        roomLabel.numberOfLines = 2

        imageView.skeletonCornerRadius = 15
        roomLabel.linesCornerRadius = 4
        roomStateView.skeletonCornerRadius = 4
    }
}
