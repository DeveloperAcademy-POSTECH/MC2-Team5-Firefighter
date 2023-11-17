//
//  InvitedCodeView.swift
//  Manito
//
//  Created by 이성호 on 11/4/23.
//

import Combine
import UIKit

import SnapKit

final class InvitedCodeView: UIView, BaseViewType {
    
    // MARK: - ui components
    
    private let invitedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.Image.codeBackground)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.Button.xmark, for: .normal)
        return button
    }()
    private let roomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let roomDateLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    private let roomImageView = UIImageView(image: UIImage.Image.characterBrown)
    private let roomPersonLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 24)
        return label
    }()
    private let roomPersonView: UIView = UIView()
    private let roomInviteCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.blue.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = .font(.regular, ofSize: 50)
        return button
    }()
    private let roomInviteInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        label.text = TextLiteral.CreateRoom.invitedCodeTitle.localized()
        label.textColor = .backgroundGrey
        return label
    }()
    
    // MARK: - property
    
    var closeButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.closeButton.tapPublisher
    }
    
    var codeButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.roomInviteCodeButton.tapPublisher
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public func
    
    func setupLayout() {
        self.addSubview(self.invitedImageView)
        self.invitedImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(142)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.height.equalTo(463)
        }
        
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(SizeLiteral.leadingTrailingPadding)
            $0.height.width.equalTo(44)
        }
        
        self.invitedImageView.addSubview(self.roomTitleLabel)
        self.roomTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.invitedImageView.snp.top).inset(125)
            $0.centerX.equalToSuperview()
        }
        
        self.invitedImageView.addSubview(self.roomDateLabel)
        self.roomDateLabel.snp.makeConstraints {
            $0.top.equalTo(self.roomTitleLabel.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
        
        self.invitedImageView.addSubview(self.roomPersonView)
        self.roomPersonView.snp.makeConstraints {
            $0.top.equalTo(self.roomDateLabel.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
        
        self.invitedImageView.addSubview(self.roomInviteCodeButton)
        self.roomInviteCodeButton.snp.makeConstraints {
            $0.top.equalTo(self.roomPersonView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(242)
            $0.height.equalTo(65)
        }
        
        self.invitedImageView.addSubview(self.roomInviteInfoLabel)
        self.roomInviteInfoLabel.snp.makeConstraints {
            $0.top.equalTo(self.roomInviteCodeButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        self.roomPersonView.addSubview(self.roomImageView)
        self.roomImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.width.equalTo(60)
        }
        
        self.addSubview(self.roomPersonLabel)
        self.roomPersonLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(roomImageView.snp.trailing)
            $0.centerY.equalTo(roomImageView.snp.centerY)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    func updateRoomInfo(roomInfo: RoomListItem) {
        self.roomTitleLabel.text = roomInfo.title
        self.roomDateLabel.text = "\(roomInfo.startDate) ~ \(roomInfo.endDate)"
        self.roomPersonLabel.text = TextLiteral.Common.xPeople.localized(with: roomInfo.capacity)
    }
    
    func updateCodeButtonTitle(code: String) {
        self.roomInviteCodeButton.setTitle(code, for: .normal)
    }
}
