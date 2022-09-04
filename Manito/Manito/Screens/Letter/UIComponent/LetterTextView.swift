//
//  LetterTextView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class LetterTextView: UIView {
    
    var applySendButtonEnabled: (() -> ())?

    // MARK: - property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.letterTextViewTitleLabel
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    lazy var letterTextView: UITextView = {
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
        
        return textView
    }()
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 16)
        label.text = "0/\(maxCount)"
        return label
    }()
    private let maxCount = 100
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        addSubview(letterTextView)
        letterTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.height.equalTo(108)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints {
            $0.top.equalTo(letterTextView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setCounter(count: Int) {
        countLabel.text = "\(count)/\(maxCount)"
        checkMaxLength(textView: letterTextView, maxLength: maxCount)
    }
    
    private func checkMaxLength(textView: UITextView, maxLength: Int) {
        if (textView.text?.count ?? 0 > maxLength) {
            textView.deleteBackward()
        }
    }
}

// MARK: - UITextViewDelegate
extension LetterTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setCounter(count: textView.text?.count ?? 0)
        applySendButtonEnabled?()
    }
}
