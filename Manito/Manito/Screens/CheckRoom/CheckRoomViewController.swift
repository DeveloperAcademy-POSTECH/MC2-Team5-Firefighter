//
//  CheckRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

class CheckRoomViewController: UIViewController, BaseViewControllerType, Navigationable {
    var roomId: Int?
    var roomInfo: ParticipatedRoomInfoDTO?
    
    // MARK: - Property
    
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
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        button.addAction(action, for: .touchUpInside)
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
        let action = UIAction { [weak self] _ in
            guard let id = self?.roomId else { return }
            self?.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .nextNotification, object: nil, userInfo: ["roomId": id])
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()
        self.setupViewController()
        self.setupNavigation()
    }

    // MARK: - base func
    
    func setupLayout() {
        view.addSubview(roomInfoImageView)
        roomInfoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(roomInfoImageView.snp.width).multipliedBy(1.15)
        }
        
        roomInfoImageView.addSubview(roomInfoView)
        roomInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.trailing.equalToSuperview()
        }
        
        roomInfoImageView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(roomInfoView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        roomInfoImageView.addSubview(noButton)
        noButton.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(Size.leadingTrailingPadding)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
            $0.leading.equalToSuperview().inset(48)
        }
        
        roomInfoImageView.addSubview(yesButton)
        yesButton.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(Size.leadingTrailingPadding)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
            $0.trailing.equalToSuperview().inset(48)
        }
    }
    
    func configureUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    // MARK: - func
    
    private func setupViewController() {
        guard let title = roomInfo?.title,
              let startDate = roomInfo?.startDate,
              let endDate = roomInfo?.endDate,
              let capacity = roomInfo?.capacity else { return }
        roomInfoView.roomLabel.text = title
        roomInfoView.dateLabel.text = "\(startDate) ~ \(endDate)"
        roomInfoView.peopleInfoView.peopleLabel.text = "X \(capacity)인"
    }
}
