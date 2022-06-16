//
//  CheckRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit

class CheckRoomViewController: BaseViewController {
    
    // MARK: - Property
    
    private var roomInfoImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
    }()
    
    private var roomInfoView = RoomInfoView()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "이 방으로 입장할까요?"
        label.font = .font(.regular, ofSize: 18)
        return label
    }()
    
    private let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("NO", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 35)
        button.backgroundColor = UIColor(hex: "#EDC845")
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(didTapNoButton), for: .touchUpInside)
        return button
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("YES", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 35)
        button.backgroundColor = UIColor(hex: "#EDC845")
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(didTapYesButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
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
            $0.top.leading.trailing.equalToSuperview()
        }
        
        roomInfoImageView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(roomInfoView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        roomInfoImageView.addSubview(noButton)
        noButton.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(16)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(48)
        }
        
        roomInfoImageView.addSubview(yesButton)
        yesButton.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(16)
            $0.width.equalTo(110)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(48)
        }
    }
    
    // MARK: - Configure
    override func configUI() {
        super.configUI()
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    // MARK: - Selectors
    @objc func didTapNoButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapYesButton() {
        dismiss(animated: true, completion: nil)
    }
}
