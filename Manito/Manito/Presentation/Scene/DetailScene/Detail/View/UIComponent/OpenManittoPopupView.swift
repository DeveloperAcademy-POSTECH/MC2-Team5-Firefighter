//
//  OpenManittoPopupView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/28.
//

import Combine
import UIKit

import SnapKit

final class OpenManittoPopupView: UIView, BaseViewType {

    // MARK: - ui component

    private let typingLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 24)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 18)
        label.text = TextLiteral.DetailIng.openManittoPopupHelperContent.localized()
        label.numberOfLines = 2
        label.addLabelSpacing()
        label.textAlignment = .center
        label.makeShadow(color: .black,
                         opacity: 0.5,
                         offset: CGSize(width: 0, height: 3),
                         radius: 3)
        return label
    }()
    private let confirmButton: MainButton = {
        let button = MainButton()
        button.title = TextLiteral.Common.confirm.localized()
        return button
    }()
    private let popupImageView: UIImageView = UIImageView(image: UIImage.Image.enterRoom)
    
    // MARK: - init
    
    var confirmButtonPublisher: AnyPublisher<Void, Never> {
        return self.confirmButton.tapPublisher
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - base func

    func setupLayout() {
        self.addSubview(self.popupImageView)
        self.popupImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(UIScreen.main.bounds.size.height * 0.15)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(self.popupImageView.snp.width).multipliedBy(1.16)
        }
        
        self.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(31)
            $0.centerX.equalToSuperview()
        }
        
        self.popupImageView.addSubview(self.typingLabel)
        self.typingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-30)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.popupImageView.addSubview(self.informationLabel)
        self.informationLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(51)
            $0.centerX.equalToSuperview()
        }
    }

    func configureUI() {
        self.backgroundColor = .black.withAlphaComponent(0.8)
        self.alpha = 0.0
    }
    
    // MARK: - func

    func setupTypingAnimation(_ text: String) {
        self.animateTyping(in: self.typingLabel, text: text)
        self.typingLabel.addLabelSpacing()
    }
}

// MARK: - Helper
extension OpenManittoPopupView {
    private func animateTyping(in label: UILabel, text: String, delay: TimeInterval = 5.0) {
        label.text = ""

        let writingTask = DispatchWorkItem {
            text.forEach { char in
                DispatchQueue.main.async {
                    label.text?.append(char)
                }
                Thread.sleep(forTimeInterval: delay/100)
            }
        }

        let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
        queue.asyncAfter(deadline: .now() + 0.7, execute: writingTask)
    }
}
