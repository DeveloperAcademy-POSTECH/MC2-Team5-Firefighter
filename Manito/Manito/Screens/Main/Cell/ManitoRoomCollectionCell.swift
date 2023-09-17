//
//  ManitoRoomCell.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/12.
//

import UIKit

import SkeletonView
import SnapKit

final class ManitoRoomCollectionViewCell: UICollectionViewCell, BaseViewType {
    
    private enum RoomStatus: String {
        case PRE = "대기중"
        case PROCESSING = "진행중"
        case POST = "완료"
    }
    
    // MARK: - ui component
    
    private let imageView: UIImageView = UIImageView(image: ImageLiterals.imgNi)
    let memberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    let roomLabel: UILabel = {
        let label = UILabel()
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
    lazy var roomStateView: RoomStateView = RoomStateView()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(9)
            $0.width.height.equalTo(30)
        }
        
        self.contentView.addSubview(self.memberLabel)
        self.memberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalTo(self.imageView.snp.trailing).offset(4)
        }
        
        self.contentView.addSubview(self.roomLabel)
        self.roomLabel.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(17)
        }
        
        self.contentView.addSubview(self.roomStateView)
        self.roomStateView.snp.makeConstraints {
            $0.top.equalTo(self.roomLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(12)
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }
        
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.backgroundColor = .darkGrey002.withAlphaComponent(0.8)
        self.makeBorderLayer(color: UIColor.white.withAlphaComponent(0.5))
        
        [self, self.imageView, self.roomLabel, self.roomStateView].forEach {
            $0.isSkeletonable = true
        }
        
        self.roomLabel.numberOfLines = 2

        self.imageView.skeletonCornerRadius = 15
        self.roomLabel.linesCornerRadius = 4
        self.roomStateView.skeletonCornerRadius = 4
    }
}
