//
//  BottomOfSendLetterView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class BottomOfSendLetterView: UIView {
    
    // MARK: - ui component
    
    private let sendLetterButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.sendLetterViewSendLetterButton
        return button
    }()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(73)
        }
        
        self.addSubview(self.sendLetterButton)
        self.sendLetterButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .backgroundGrey
    }

    func addAction(_ action: @escaping (() -> Void)) {
        self.sendLetterButton.action = action
    }
}
