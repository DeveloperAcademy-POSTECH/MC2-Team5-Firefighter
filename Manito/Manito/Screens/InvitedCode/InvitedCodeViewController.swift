//
//  InvitedCodeViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class InvitedCodeViewController: BaseViewController {

    // MARK: - property
    private let invitedImageView = UIImageView(image: ImageLiterals.imgCodeBackground)
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        return button
    }()
    private let roomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        label.text = "명예소방관"
        return label
    }()
    private let roomDateLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        label.text = "2022.06.06 ~ 2022.06.12"
        return label
    }()
    private let roomImage = UIImageView(image: ImageLiterals.imgCharacterBrown)
    private let roomPersonLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 24)
        label.text = "X 8인"
        return label
    }()
    private lazy var roomPersonView: UIView = {
        let view = UIView()
        view.addSubview(roomImage)
        roomImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.width.equalTo(60)
        }
        view.addSubview(roomPersonLabel)
        roomPersonLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(roomImage.snp.trailing)
            $0.centerY.equalTo(roomImage.snp.centerY)
        }
        return view
    }()
    private let roomInviteCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 50)
        label.text = "HSSSER"
        label.textColor = .codeBlue
        return label
    }()
    private let roomInviteInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        label.text = TextLiteral.invitedCodeViewCOntroller
        label.textColor = .backgroundGrey
        return label
    }()
    
    // MARK: - life cycle
    // MARK: - configure
    override func render() {
        view.addSubview(invitedImageView)
        invitedImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(142)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(463)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Size.leadingTrailingPadding)
            $0.height.width.equalTo(44)
        }
        
        invitedImageView.addSubview(roomTitleLabel)
        roomTitleLabel.snp.makeConstraints {
            $0.top.equalTo(invitedImageView.snp.top).inset(125)
            $0.centerX.equalToSuperview()
        }
        
        invitedImageView.addSubview(roomDateLabel)
        roomDateLabel.snp.makeConstraints {
            $0.top.equalTo(roomTitleLabel.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
        
        invitedImageView.addSubview(roomPersonView)
        roomPersonView.snp.makeConstraints {
            $0.top.equalTo(roomDateLabel.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(60)
        }
        
        invitedImageView.addSubview(roomInviteCodeLabel)
        roomInviteCodeLabel.snp.makeConstraints {
            $0.top.equalTo(roomPersonView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
        }
        
        invitedImageView.addSubview(roomInviteInfoLabel)
        roomInviteInfoLabel.snp.makeConstraints {
            $0.top.equalTo(roomInviteCodeLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configUI() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    // MARK: - selectors
    // MARK: - functions
}
