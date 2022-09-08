//
//  CheckRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

class CheckRoomViewController: BaseViewController {
    private let checkRoomInfoService: RoomProtocol = RoomAPI(apiService: APIService(), environment: .development)
    var inviteCode: String?
    
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
        let button = UIButton()
        button.setTitle(TextLiteral.checkRoomViewControllerNoButtonLabel, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 35)
        button.backgroundColor = .yellow
        button.makeShadow(color: .shadowYellow, opacity: 1.0, offset: CGSize(width: 0, height: 4), radius: 1)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(didTapNoButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextLiteral.checkRoomViewControllerYesBUttonLabel, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 35)
        button.backgroundColor = .yellow
        button.makeShadow(color: .shadowYellow, opacity: 1.0, offset: CGSize(width: 0, height: 4), radius: 1)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(didTapYesButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        requestVerificationRoomCode()
    }
    
    override func render() {
        view.addSubview(roomInfoImageView)
        roomInfoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(roomInfoImageView.snp.width).multipliedBy(1.15)
        }
        
        roomInfoImageView.addSubview(roomInfoView)
        roomInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.trailing.bottom.equalToSuperview()
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
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(48)
        }
        
        roomInfoImageView.addSubview(yesButton)
        yesButton.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(Size.leadingTrailingPadding)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(48)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    // MARK: - Selectors
    @objc private func didTapNoButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapYesButton() {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .nextNotification, object: nil)
    }
    
    // MARK: - API
    
    private func requestVerificationRoomCode() {
        Task {
            do {
                let response = try await checkRoomInfoService
                    .getVerification(body: inviteCode ?? "")
                dump(response)
                if let data = response {
                    guard let title = data.title,
                          let startDate = data.startDate,
                          let endDate = data.endDate,
                          let capacity = data.capacity
                    else { return }
                    roomInfoView.roomLabel.text = title
                    roomInfoView.dateLabel.text = "\(startDate.subStringToDate()) ~ \(endDate.subStringToDate())"
                    roomInfoView.peopleInfo.peopleLabel.text = "X \(capacity)인"
                }
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                makeAlert(title: "해당하는 애니또 방이 없습니다", message: "이미 참여중인 방이거나,\n 초대 코드를 확인해 주세요", okAction: { [weak self] _ in
                    self?.dismiss(animated: true)
                })
                print("client Error: \(String(describing: message))")
            }
        }
    }
}
