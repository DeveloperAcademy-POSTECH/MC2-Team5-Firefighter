//
//  CreateNickNameViewController.swift
//  Manito
//
//  Created by LeeSungHo on 2022/06/12.
//

import UIKit

import SnapKit

class CreateNickNameViewController: BaseViewController {
    
    // MARK: - Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 설정"
        label.font = .font(.regular, ofSize: 34)
        return label
    }()
    private let roomsNameTextField: UITextField = {
        let texField = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.font(.regular, ofSize: 18)
        ]
        texField.backgroundColor = UIColor.subBackgroundGrey
        texField.attributedPlaceholder = NSAttributedString(string: "닉네임을 적어주세요", attributes:attributes)
        texField.layer.cornerRadius = 10
        texField.layer.masksToBounds = true
        texField.layer.borderWidth = 1
        texField.layer.borderColor = UIColor.white.cgColor
        texField.textAlignment = .center
        return texField
    }()
    private let doneButton : MainButton = {
        let button = MainButton()
        button.title = "완료"
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func render() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(66)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        view.addSubview(roomsNameTextField)
        roomsNameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(60)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(23)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    override func configUI() {
        super.configUI()
    }
}
