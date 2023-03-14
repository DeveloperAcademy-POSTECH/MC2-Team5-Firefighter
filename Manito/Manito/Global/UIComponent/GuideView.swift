//
//  GuideView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/03/09.
//

import UIKit

import SnapKit

final class GuideView: UIView {

    // MARK: - ui component

    private let guideButton: UIButton = UIButton()
    private let guideBoxImageView: UIImageView = UIImageView(image: ImageLiterals.imgGuideBox)
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .font(.regular, ofSize: 14)
        label.contentMode = .center
        return label
    }()

    // MARK: - init

    init(content: String) {
        super.init(frame: .zero)
        self.setupLayout()
        self.configureUI()
        self.setupGuideAction()
        self.configureGuideContent(to: content)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    private func setupLayout() {
        self.addSubview(self.guideBoxImageView)
        self.guideBoxImageView.snp.makeConstraints {
            $0.top.equalTo(self.guideButton.snp.bottom).offset(-10)
            $0.trailing.equalTo(self.guideButton.snp.trailing).offset(-12)
            $0.width.equalTo(270)
            $0.height.equalTo(90)
        }

        self.guideBoxImageView.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }

    private func configureUI() {
        self.guideBoxImageView.isHidden = true
    }

    private func setupGuideAction() {
        let guideAction = UIAction { [weak self] _ in
            self?.guideBoxImageView.isHidden.toggle()
        }
        self.guideButton.addAction(guideAction, for: .touchUpInside)
    }

    private func configureGuideContent(to content: String) {
        self.guideLabel.text = content
        self.guideLabel.addLabelSpacing()
        self.guideLabel.textAlignment = .center
        self.applyColorToTargetContent(content)
    }
    
    private func applyColorToTargetContent(_ content: String) {
        guard let targetTitle = content.split(separator: "\n").map({ String($0) }).first else { return }
        self.guideLabel.applyColor(to: targetTitle, with: .subOrange)
    }
}
