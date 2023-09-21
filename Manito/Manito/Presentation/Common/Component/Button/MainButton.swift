//
//  MainButton.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/11.
//

import UIKit

import SnapKit

final class MainButton: UIButton {
    
    private enum Size {
        static let spacing: CGFloat = 20.0
        static let height: CGFloat = 60.0
        static let width: CGFloat = UIScreen.main.bounds.size.width - Size.spacing * 2
    }
    
    // MARK: - property
    
    var title: String? {
        didSet { setupAttribute() }
    }
    
    var isDisabled: Bool = false {
        didSet { setupAttribute() }
    }
    
    var hasShadow: Bool = false {
        didSet { setupShadow() }
    }

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        render()
        configUI()
    }
    
    // MARK: - func
    
    private func render() {
        self.snp.makeConstraints {
            $0.width.equalTo(Size.width)
            $0.height.equalTo(Size.height)
        }
    }
    
    private func configUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 30
        titleLabel?.font = .font(.regular, ofSize: 20)
        setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        setTitleColor(.white, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.3), for: .disabled)
        setBackgroundColor(.mainRed, for: .normal)
        setBackgroundColor(.mainRed.withAlphaComponent(0.3), for: .disabled)
        setBackgroundColor(.mainRed.withAlphaComponent(0.5), for: .highlighted)
    }
    
    private func setupAttribute() {
        if let title = title {
            setTitle(title, for: .normal)
        }
        
        // COLOR: disable색상 추가 #823029
        isEnabled = !isDisabled
    }
    
    private func setupShadow() {
        makeShadow(color: .shadowRed, opacity: 1.0, offset: CGSize(width: 0, height: 6), radius: 1)
    }
}
