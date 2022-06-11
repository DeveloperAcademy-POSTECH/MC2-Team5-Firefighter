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
        static let spacing: CGFloat = 16.0
        static let height: CGFloat = 60.0
        static let width: CGFloat = UIScreen.main.bounds.size.width - Size.spacing * 2
    }
    
    // MARK: - property
    
    override var isHighlighted: Bool {
         get {
             return super.isHighlighted
         }
         set {
             backgroundColor = isHighlighted ? .mainRed : .mainRed.withAlphaComponent(0.5)
             super.isHighlighted = newValue
         }
     }
    
    var title: String? {
        didSet {
            setupAttribute()
        }
    }
    
    var isDisabled: Bool = false {
        didSet {
            setupAttribute()
        }
    }

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
            $0.width.equalTo(Size.width)
            $0.height.equalTo(Size.height)
        }
    }
    
    private func configUI() {
        layer.cornerRadius = 30
        titleLabel?.font = .font(.regular, ofSize: 20)
        setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
    }
    
    private func setupAttribute() {
        if let title = title {
            setTitle(title, for: .normal)
        }
        
        backgroundColor = isDisabled ? .mainRed.withAlphaComponent(0.3) : .mainRed
        setTitleColor(isDisabled ? .white.withAlphaComponent(0.3) : .white, for: .normal)
        isEnabled = !isDisabled
    }
}
