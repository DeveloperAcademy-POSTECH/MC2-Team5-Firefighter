//
//  CreateLetterTextView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class CreateLetterTextView: UIView {
    
    var applySendButtonEnabled: (() -> ())?

    // MARK: - ui component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.letterTextViewTitleLabel
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private lazy var letterTextView: UITextView = {
        let textView = UITextView()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        
        textView.typingAttributes = [.paragraphStyle: paragraphStyle]
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 12, bottom: 17, right: 12)
        textView.font = .font(.regular, ofSize: 16)
        textView.textColor = .white
        textView.backgroundColor = .darkGrey004
        textView.makeBorderLayer(color: .white)
        textView.delegate = self
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        return textView
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 16)
        return label
    }()

    // MARK: - property

    var hasText: Bool {
        return self.letterTextView.hasText
    }
    var text: String? {
        guard self.letterTextView.text != "" && self.letterTextView.text != nil else { return nil }
        return self.letterTextView.text
    }
    private let maxCount: Int = 100


    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setCounter(count: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        self.addSubview(self.letterTextView)
        self.letterTextView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(17)
            $0.height.equalTo(108)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(self.countLabel)
        self.countLabel.snp.makeConstraints {
            $0.top.equalTo(self.letterTextView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setCounter(count: Int) {
        self.countLabel.text = "\(count)/\(self.maxCount)"
    }
    
    private func checkMaxLength(textView: UITextView, maxLength: Int) {
        if (textView.text?.count ?? 0 > maxLength) {
            textView.deleteBackward()
        }
    }
}

// MARK: - UITextViewDelegate
extension CreateLetterTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.setCounter(count: textView.text?.count ?? 0)
        self.checkMaxLength(textView: self.letterTextView, maxLength: self.maxCount)
        self.applySendButtonEnabled?()
    }
}
