//
//  SendLetterTextView.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import Combine
import UIKit

import SnapKit

final class SendLetterTextView: UIView {
    
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

    var textSubject: CurrentValueSubject<String, Never> = CurrentValueSubject("")
    var hasTextSubject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }

    @available(*, unavailable)
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
    
    func updateCounter(_ count: Int, maxCount: Int) {
        self.countLabel.text = "\(count)/\(maxCount)"
    }
    
    func updateTextViewContent(to content: String) {
        self.letterTextView.text = content
    }
}

// MARK: - UITextViewDelegate
extension SendLetterTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.hasTextSubject.send(textView.hasText)
        self.textSubject.send(textView.text)
    }
}
