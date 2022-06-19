//
//  ChooseRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/18.
//

import UIKit

import SnapKit

class ChooseCharacterViewController: BaseViewController {
    
    // MARK: - Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캐릭터 선택"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "당신만의 캐릭터를 정해주세요."
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .grey002
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(ImageLiterals.btnXmark, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let enterButton: MainButton = {
        let button = MainButton()
        button.title = "선택"
        button.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
        return button
    }()
    
    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(9)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(enterButton)
        enterButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(57)
            $0.height.equalTo(60)
        }
    }
    
    // MARK: - Configure
    override func configUI() {
        super.configUI()
    }
    
    // MARK: - Selectors
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapEnterButton() {
        dismiss(animated: true, completion: nil)
    }
}
