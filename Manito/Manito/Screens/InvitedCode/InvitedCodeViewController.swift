//
//  InvitedCodeViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

class InvitedCodeViewController: UIViewController, BaseViewControllerType, Navigationable {
    
    var roomInfo: RoomListItem
    var code: String
    
    init(roomInfo: RoomListItem, code: String){
        self.roomInfo = roomInfo
        self.code = code
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - property
    private let invitedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.Image.codeBackground)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        button.setImage(UIImage.Button.xmark, for: .normal)
        return button
    }()
    private lazy var roomTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 34)
        label.text = roomInfo.title
        return label
    }()
    private lazy var roomDateLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        label.text = "\(roomInfo.startDate) ~ \(roomInfo.endDate)"
        return label
    }()
    private let roomImage = UIImageView(image: UIImage.Image.characterBrown)
    private lazy var roomPersonLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 24)
        label.text = TextLiteral.Common.xPeople.localized(with: roomInfo.capacity)
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
    private lazy var roomInviteCodeButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonAction = UIAction { [weak self] _ in
            if let code = self?.code {
                ToastView.showToast(code: code, message: TextLiteral.DetailWait.toastCopyMessage.localized(), controller: self ?? UIViewController())
            }
        }
        button.setTitle(code, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.blue.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = .font(.regular, ofSize: 50)
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private let roomInviteInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        label.text = TextLiteral.CreateRoom.invitedCodeTitle.localized()
        label.textColor = .backgroundGrey
        return label
    }()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()
        self.setupNavigation()
    }

    // MARK: - base func
    
    func setupLayout() {
        view.addSubview(invitedImageView)
        invitedImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(142)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.height.equalTo(463)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(SizeLiteral.leadingTrailingPadding)
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
        
        invitedImageView.addSubview(roomInviteCodeButton)
        roomInviteCodeButton.snp.makeConstraints {
            $0.top.equalTo(roomPersonView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(242)
            $0.height.equalTo(65)
        }
        
        invitedImageView.addSubview(roomInviteInfoLabel)
        roomInviteInfoLabel.snp.makeConstraints {
            $0.top.equalTo(roomInviteCodeButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.8)
    }
}
