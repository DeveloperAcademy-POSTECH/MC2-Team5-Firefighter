//
//  SendLetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class SendLetterView: UIView {
    
    // MARK: - property
    
    private let sendLetterButton: UIButton = {
        let button = UIButton()
        button.setTitle("쪽지 쓰기", for: .normal)
        button.backgroundColor = .mainRed
        button.layer.cornerRadius = 30
        button.titleLabel?.font = .font(.regular, ofSize: 20)
        return button
    }()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        self.snp.makeConstraints {
            $0.height.equalTo(73)
        }
        
        self.addSubview(sendLetterButton)
        sendLetterButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }
    
    private func configUI() {
        backgroundColor = .backgroundGrey
    }
}
