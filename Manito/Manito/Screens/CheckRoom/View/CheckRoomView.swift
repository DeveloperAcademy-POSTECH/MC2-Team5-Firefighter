//
//  CheckRoomView.swift
//  Manito
//
//  Created by 이성호 on 2023/09/05.
//

import UIKit

import SnapKit

final class CheckRoomView: UIView {
    
    // MARK: - ui component
    
    private let roomInfoImageView: UIImageView = {
        let image = UIImageView()
        image.image = ImageLiterals.imgEnterRoom
        image.isUserInteractionEnabled = true
        return image
    }()
    let roomInfoView = RoomInfoView()
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.checkRoomViewControllerQuestionLabel
        label.font = .font(.regular, ofSize: 18)
        label.makeShadow(color: .black, opacity: 0.25, offset: CGSize(width: 0, height: 3), radius: 0)
        return label
    }()
    private lazy var noButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.checkRoomViewControllerNoButtonLabel, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 35)
        button.backgroundColor = .yellow
        button.makeShadow(color: .shadowYellow, opacity: 1.0, offset: CGSize(width: 0, height: 4), radius: 1)
        button.layer.cornerRadius = 22
//        let action = UIAction { [weak self] _ in
//            self?.dismiss(animated: true, completion: nil)
//        }
//        button.addAction(action, for: .touchUpInside)
        return button
    }()
    private lazy var yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.checkRoomViewControllerYesBUttonLabel, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 35)
        button.backgroundColor = .yellow
        button.makeShadow(color: .shadowYellow, opacity: 1.0, offset: CGSize(width: 0, height: 4), radius: 1)
        button.layer.cornerRadius = 22
//        let action = UIAction { [weak self] _ in
//            guard let id = self?.roomId else { return }
//            self?.dismiss(animated: true, completion: nil)
//            NotificationCenter.default.post(name: .nextNotification, object: nil, userInfo: ["roomId": id])
//        }
//        button.addAction(action, for: .touchUpInside)
        return button
    }()
    // MARK: - property
    
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
        
        self.roomInfoImageView.addSubview(self.roomInfoView)
        self.roomInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.roomInfoImageView.addSubview(self.questionLabel)
        self.questionLabel.snp.makeConstraints {
            $0.top.equalTo(self.roomInfoView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        self.roomInfoImageView.addSubview(self.noButton)
        self.noButton.snp.makeConstraints {
            $0.top.equalTo(self.questionLabel.snp.bottom).offset(Size.leadingTrailingPadding)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
            $0.leading.equalToSuperview().inset(48)
        }
        
        self.roomInfoImageView.addSubview(self.yesButton)
        self.yesButton.snp.makeConstraints {
            $0.top.equalTo(self.questionLabel.snp.bottom).offset(Size.leadingTrailingPadding)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
            $0.trailing.equalToSuperview().inset(48)
        }
    }
}
