//
//  MainButton.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class MainButton: ThrottleButton {
    
    private enum InternalSize {
        static let spacing: CGFloat = 20.0
        static let height: CGFloat = 60.0
        static let width: CGFloat = UIScreen.main.bounds.size.width - InternalSize.spacing * 2
    }
    
    // MARK: - property
    
    var title: String? {
        didSet { self.setupAttribute() }
    }
    
    var isDisabled: Bool = false {
        didSet { self.setupAttribute() }
    }
    
    var hasShadow: Bool = false {
        didSet { self.setupShadow() }
    }

    var action: (() -> Void)? {
        willSet(action) {
            if let action {
                self.throttle(delay: 3.0, callback: action)
            }
        }
    }

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupLayout()
        self.configureUI()
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(InternalSize.width)
            $0.height.equalTo(InternalSize.height)
        }
    }
    
    private func configureUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 30
        self.titleLabel?.font = .font(.regular, ofSize: 20)
        self.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white.withAlphaComponent(0.3), for: .disabled)
        self.setBackgroundColor(.mainRed, for: .normal)
        self.setBackgroundColor(.mainRed.withAlphaComponent(0.3), for: .disabled)
        self.setBackgroundColor(.mainRed.withAlphaComponent(0.5), for: .highlighted)
    }
    
    private func setupAttribute() {
        if let title = self.title {
            self.setTitle(title, for: .normal)
        }
        
        self.isEnabled = !isDisabled
    }
    
    private func setupShadow() {
        self.makeShadow(color: .shadowRed, opacity: 1.0, offset: CGSize(width: 0, height: 6), radius: 1)
    }
}
