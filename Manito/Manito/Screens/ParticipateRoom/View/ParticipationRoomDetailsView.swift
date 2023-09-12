//
//  ParticipationRoomDetails.swift
//  Manito
//
//  Created by 이성호 on 2023/09/05.
//

import Combine
import UIKit

import SnapKit

final class ParticipationRoomDetailsView: UIView {
    
    // MARK: - ui component
    
    private let roomInfoImageView: UIImageView = {
        let image = UIImageView()
        image.image = ImageLiterals.imgEnterRoom
        image.isUserInteractionEnabled = true
        return image
    }()
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
    private let peopleImageView = UIImageView(image: ImageLiterals.imgNi)
    private let peopleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 24)
        return label
    }()
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.checkRoomViewControllerQuestionLabel
        label.font = .font(.regular, ofSize: 18)
        label.makeShadow(color: .black, opacity: 0.25, offset: CGSize(width: 0, height: 3), radius: 0)
        return label
    }()
    private let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.checkRoomViewControllerNoButtonLabel, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 35)
        button.backgroundColor = .yellow
        button.makeShadow(color: .shadowYellow, opacity: 1.0, offset: CGSize(width: 0, height: 4), radius: 1)
        button.layer.cornerRadius = 22
        return button
    }()
    private let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.checkRoomViewControllerYesBUttonLabel, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 35)
        button.backgroundColor = .yellow
        button.makeShadow(color: .shadowYellow, opacity: 1.0, offset: CGSize(width: 0, height: 4), radius: 1)
        button.layer.cornerRadius = 22
        return button
    }()
    
    // MARK: - property
    
    lazy var noButtonDidTapPublisher = self.noButton.tapPublisher
    lazy var yesButtonDidTapPublisher = self.yesButton.tapPublisher
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.roomInfoImageView)
        self.roomInfoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(self.roomInfoImageView.snp.width).multipliedBy(1.15)
        }
        
        self.roomInfoImageView.addSubview(self.roomLabel)
        self.roomLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.height.equalTo(35)
            $0.centerX.equalToSuperview()
        }
        
        self.roomInfoImageView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.roomLabel.snp.bottom).offset(8)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        
        self.roomInfoImageView.addSubview(self.peopleImageView)
        self.peopleImageView.snp.makeConstraints {
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(7)
            $0.width.height.equalTo(60)
            $0.trailing.equalTo(self.snp.centerX).offset(-10)
        }
        
        self.roomInfoImageView.addSubview(self.peopleLabel)
        self.peopleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.peopleImageView.snp.trailing).offset(5)
            $0.centerY.equalTo(self.peopleImageView.snp.centerY)
        }
  
        self.roomInfoImageView.addSubview(self.noButton)
        self.noButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(15)
            $0.trailing.equalTo(self.snp.centerX).offset(-15)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
        }
        
        self.roomInfoImageView.addSubview(self.yesButton)
        self.yesButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(15)
            $0.leading.equalTo(self.snp.centerX).offset(15)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
        }
        
        self.roomInfoImageView.addSubview(self.questionLabel)
        self.questionLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.noButton.snp.top).offset(-15)
            $0.centerX.equalToSuperview()
        }
    }
    
    func updateRoomInfo(roomInfo: ParticipatedRoomInfo) {
        let title = roomInfo.title
        let capacity = roomInfo.capacity
        let startDate = roomInfo.startDate
        let endDate = roomInfo.endDate
        
        self.roomLabel.text = title
        self.dateLabel.text = "\(startDate) ~ \(endDate)"
        self.peopleLabel.text = "X \(capacity)인"
    }
}
